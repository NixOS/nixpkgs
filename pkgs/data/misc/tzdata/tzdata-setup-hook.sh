tzdataHook() {
    export TZDIR=@out@/share/zoneinfo
}

envHooks+=(tzdataHook)
crossEnvHooks+=(tzdataHook)
