qtPluginPrefix=@qtPluginPrefix@
qtQmlPrefix=@qtQmlPrefix@
qtDocPrefix=@qtDocPrefix@

. @fix_qt_builtin_paths@
. @fix_qt_module_paths@

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

qmakePathHook() {
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
qtEnvHostTargetHook() {
    if providesQtRuntime "$1" && [ "z${!outputBin}" != "z${!outputDev}" ]
    then
        propagatedBuildInputs+=" $1"
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
    postPhases="${postPhases-}${postPhases:+ }postPatchMkspecs"
fi
