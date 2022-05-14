xdtEnvHook() {
    addToSearchPath ACLOCAL_PATH $1/share/aclocal
}

addEnvHooks "$hostOffset" xdtEnvHook

xdtAutogenPhase() {
    mkdir -p m4
    NOCONFIGURE=1 xdt-autogen
}

preConfigurePhases+=(xdtAutogenPhase)
