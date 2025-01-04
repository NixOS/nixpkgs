module Main where

foreign import data Effect :: Type -> Type
data Unit = Unit

foreign import log :: String -> Effect Unit

main :: Effect Unit
main = log "hello world"
