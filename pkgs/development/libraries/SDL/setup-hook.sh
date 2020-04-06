addSDLPath () {
  if [ -e "$1/include/SDL" ]; then
    export SDL_PATH="${SDL_PATH-}${SDL_PATH:+ }$1/include/SDL"
  fi
  if [ -e "$1/lib" ]; then
    export SDL_LIB_PATH="${SDL_LIB_PATH-}${SDL_LIB_PATH:+ }-L$1/lib"
  fi
}

addEnvHooks "$hostOffset" addSDLPath
