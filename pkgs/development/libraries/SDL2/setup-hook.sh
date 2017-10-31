addSDL2Path () {
  if [ -e "$1/include/SDL2" ]; then
    export SDL2_PATH="$SDL2_PATH $1/include/SDL2"
  fi
}

if test -n "$crossConfig"; then
  crossEnvHooks+=(addSDL2Path)
else
  envHooks+=(addSDL2Path)
fi
