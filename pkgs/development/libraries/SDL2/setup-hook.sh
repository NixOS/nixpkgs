addSDL2Path () {
  prependToSearchPath SDL2_PATH "$1/include/SDL2"
}

if test -n "$crossConfig"; then
  crossEnvHooks+=(addSDL2Path)
else
  envHooks+=(addSDL2Path)
fi
