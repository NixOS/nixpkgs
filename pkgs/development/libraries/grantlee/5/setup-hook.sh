grantleePluginPrefix=@grantleePluginPrefix@

providesGrantleeRuntime() {
    [ -d "$1/$grantleePluginPrefix" ]
}

_grantleeEnvHook() {
    if providesGrantleeRuntime "$1"; then
        propagatedBuildInputs+=" $1"
        propagatedUserEnvPkgs+=" $1"
    fi
}
if [ "$crossEnv" ]; then
    crossEnvHooks+=(_grantleeEnvHook)
else
    envHooks+=(_grantleeEnvHook)
fi
