# Script para extração e análise de dados provenientes do Twitter
# usando a API pública da plataforma
# Evento: CODA.BR - Congresso Brasileiro de Jornalismo de Dados e Métodos Digitais
# Workshop: Criando seu primeiro grafo: Como usar grafos para entender interações entre usuários
# Facilitador: Janderson Pereira Toth ( @trifenol)

# Instalando as bibliotecas usadas.
install.packages(c("plyr","dplyr","rtweet","readr","ggplot2"))
library(plyr)
library(dplyr)
library(rtweet)
library(readr)
library(ggplot2)

# dplyr:
# rtweet: biblioteca para acesso a API do Twitter
# plyr:
# readr: pacote para leitura/manipular/salvar arquivos em csv

# Criando o token de acesso a API do Twitter
# Acesse https://developer.twitter.com/ e crie seu app de acesso a API.
# A chave abaixo é fake :D
token <- create_token(
  app = "Chave_Toth",
  consumer_key = "feOfhhvL33ZO2Kb3dsfsfsdvm1NVjxTw",
  consumer_secret = "eVcmUyaeFfsdfsdfdsfds1WQgSC7Fvet3cOR7AxoRhJfgbgXW",
  access_token = "103638498-KzyyUW59eeYfdsfsdfs0sFqCyj3iNdWc9lQ",
  access_secret = "54FBqxXNYm9IDzqe3e3rOFEOne0ZK3eIY6APAxfk1")


# REALIZANDO A BUSCA HISTÓRICA E POR STREAMING
#documentação básica: https://rtweet.info/
#Verificando a função de busca histórica
?search_tweets
# Realizando a busca
busca <- search_tweets(q = "codabr19", n = 15000, retryonratelimit = T)

#Verificando a função de busca por streaming
?stream_tweets

# definindo tempo de coleta
tempo_de_busca <- 60 * 60 * 15  #15 horas

# realizando a busca por streaming
busca <- stream_tweets(q =  "codabr", timeout = tempo_de_busca)

# SALVANDO NO MODELO DO GEPHI

#verificando o intervalo das postagens
ts_plot(busca, "hours")

busca$retweet_screen_name = ifelse(is.na(busca$retweet_screen_name), 
                                   busca$quoted_screen_name, 
                                   busca$retweet_screen_name)


grafo <- busca  %>% select(screen_name, retweet_screen_name, text, status_url) %>%
  setNames(c("source","target","text","url")) %>% 
  filter(!is.na(target))

write_csv(grafo,"grafo.csv", na = "")
