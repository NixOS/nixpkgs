xdtEnvHook() {
    addToSearchPath ACLOCAL_PATH $1/share/xfce4/dev-tools/m4macros
}

envHooks+=(xdtEnvHook)

xdtAutogenPhase() {
    mkdir -p m4
    NOCONFIGURE=1 xdt-autogen
}

preConfigurePhases+=(xdtAutogenPhase)
