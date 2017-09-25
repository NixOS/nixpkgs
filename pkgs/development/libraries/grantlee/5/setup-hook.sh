grantleePluginPrefix=@grantleePluginPrefix@

providesGrantleeRuntime() {
    [ -d "$1/$grantleePluginPrefix" ]
}

_grantleeCrossEnvHook() {
    if providesQtRuntime "$1"; then
        propagatedBuildInputs+=" $1"
        propagatedUserEnvPkgs+=" $1"
    fi
}
crossEnvHooks+=(_grantleeCrossEnvHook)

_grantleeEnvHook() {
    if providesGrantleeRuntime "$1"; then
        propagatedNativeBuildInputs+=" $1"
        if [ -z "$crossConfig" ]; then
        propagatedUserEnvPkgs+=" $1"
        fi
    fi
}
envHooks+=(_grantleeEnvHook)
