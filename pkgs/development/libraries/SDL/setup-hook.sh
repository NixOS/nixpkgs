addSDLPath () {
  if [ -e "$1/include/SDL" ]; then
    export SDL_PATH="$SDL_PATH $1/include/SDL"
  fi
}

if test -n "$crossConfig"; then
  crossEnvHooks+=(addSDLPath)
else
  envHooks+=(addSDLPath)
fi
