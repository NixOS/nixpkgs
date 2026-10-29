tzdataHook() {
    export TZDIR=@out@/share/zoneinfo
}

addEnvHooks "$targetOffset" tzdataHook
