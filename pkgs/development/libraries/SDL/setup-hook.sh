addSDLPath () {
    prependToSearchPath SDL_PATH "1/include/SDL"
}

if test -n "$crossConfig"; then
    crossEnvHooks+=(addSDLPath)
else
    envHooks+=(addSDLPath)
fi
