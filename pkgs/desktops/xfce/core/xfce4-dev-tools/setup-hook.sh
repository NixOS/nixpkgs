xdtEnvHook() {
    addToSearchPath ACLOCAL_PATH $1/share/aclocal
}

envHooks+=(xdtEnvHook)

xdtAutogenPhase() {
    mkdir -p m4
    NOCONFIGURE=1 xdt-autogen
}

if [ -z "${dontUseXdtAutogenPhase-}" ]; then
    preConfigurePhases+=(xdtAutogenPhase)
fi
