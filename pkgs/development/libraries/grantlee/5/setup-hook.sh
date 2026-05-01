grantleePluginPrefix=@grantleePluginPrefix@

providesGrantleeRuntime() {
    [ -d "$1/$grantleePluginPrefix" ]
}

_grantleeEnvHook() {
    if providesGrantleeRuntime "$1"; then
        appendToVar propagatedBuildInputs "$1"
        appendToVar propagatedUserEnvPkgs "$1"
    fi
}
addEnvHooks "$hostOffset" _grantleeEnvHook
