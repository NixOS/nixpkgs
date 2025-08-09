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
qtDocPrefix=@qtDocPrefix@

. @fix_qt_builtin_paths@
. @fix_qt_module_paths@

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

providesQtRuntime() {
    [ -d "$1/$qtPluginPrefix" ] || [ -d "$1/$qtQmlPrefix" ]
}

# Build tools are often confused if QMAKE is unset.
QMAKE=@dev@/bin/qmake
export QMAKE

QMAKEPATH=
export QMAKEPATH

QMAKEMODULES=
export QMAKEMODULES

declare -Ag qmakePathSeen=()
qmakePathHook() {
    # Skip this path if we have seen it before.
    # MUST use 'if' because 'qmakePathSeen[$]' may be unset.
    if [ -n "${qmakePathSeen[$1]-}" ]; then return; fi
    qmakePathSeen[$1]=1
    if [ -d "$1/mkspecs" ]
    then
        QMAKEMODULES="${QMAKEMODULES}${QMAKEMODULES:+:}/mkspecs"
        QMAKEPATH="${QMAKEPATH}${QMAKEPATH:+:}$1"
    fi
}
envBuildHostHooks+=(qmakePathHook)

# Propagate any runtime dependency of the building package.
# Each dependency is propagated to the user environment and as a build
# input so that it will be re-propagated to the user environment by any
# package depending on the building package. (This is necessary in case
# the building package does not provide runtime dependencies itself and so
# would not be propagated to the user environment.)
declare -Ag qtEnvHostTargetSeen=()
qtEnvHostTargetHook() {
    # Skip this path if we have seen it before.
    # MUST use 'if' because 'qmakePathSeen[$]' may be unset.
    if [ -n "${qtEnvHostTargetSeen[$1]-}" ]; then return; fi
    qtEnvHostTargetSeen[$1]=1
    if providesQtRuntime "$1" && [ "z${!outputBin}" != "z${!outputDev}" ]
    then
        appendToVar propagatedBuildInputs "$1"
    fi
}
envHostTargetHooks+=(qtEnvHostTargetHook)

postPatchMkspecs() {
    # Prevent this hook from running multiple times
    dontPatchMkspecs=1

    local bin="${!outputBin}"
    local dev="${!outputDev}"
    local doc="${!outputDoc}"
    local lib="${!outputLib}"

    moveToOutput "mkspecs" "$dev"

    if [ -d "$dev/mkspecs/modules" ]; then
        fixQtModulePaths "$dev/mkspecs/modules"
    fi

    if [ -d "$dev/mkspecs" ]; then
        fixQtBuiltinPaths "$dev/mkspecs" '*.pr?'
    fi
}
if [ -z "${dontPatchMkspecs-}" ]; then
    appendToVar postPhases postPatchMkspecs
fi

qtPreHook() {
    # Check that wrapQtAppsHook is used, or it is explicitly disabled.
    if [[ -z "$__nix_wrapQtAppsHook" && -z "$dontWrapQtApps" ]]; then
        echo >&2 "Error: wrapQtAppsHook is not used, and dontWrapQtApps is not set."
        exit 1
    fi
}
appendToVar prePhases qtPreHook

fi
