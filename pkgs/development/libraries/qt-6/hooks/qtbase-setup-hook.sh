if [[ -n "${__nix_qtbase-}" ]]; then
    # Throw an error if a different version of Qt was already set up.
    if [[ "$__nix_qtbase" != "@dev@" ]]; then
        echo >&2 "Error: detected mismatched Qt dependencies:"
        echo >&2 "    @dev@"
        echo >&2 "    $__nix_qtbase"
        exit 1
    fi
else # Only set up Qt once.
__nix_qtbase="@dev@"

qtPluginPrefix=@qtPluginPrefix@
qtQmlPrefix=@qtQmlPrefix@

# Disable debug symbols if qtbase was built without debugging.
# This stops -dev paths from leaking into other outputs.
if [ -z "@debug@" ]; then
    NIX_CFLAGS_COMPILE="${NIX_CFLAGS_COMPILE-}${NIX_CFLAGS_COMPILE:+ }-DQT_NO_DEBUG"
fi

# Integration with CMake:
# Set the CMake build type corresponding to how qtbase was built.
if [ -n "@debug@" ]; then
    cmakeBuildType="Debug"
else
    cmakeBuildType="Release"
fi

qtPreHook() {
    # Check that wrapQtAppsHook is used, or it is explicitly disabled.
    if [[ -z "$__nix_wrapQtAppsHook" && -z "$dontWrapQtApps" ]]; then
        echo >&2 "Error: wrapQtAppsHook is not used, and dontWrapQtApps is not set."
        exit 1
    fi
}
prePhases+=" qtPreHook"

addQtModulePrefix () {
    addToSearchPath QT_ADDITIONAL_PACKAGES_PREFIX_PATH $1
}
addEnvHooks "$hostOffset" addQtModulePrefix

fi
