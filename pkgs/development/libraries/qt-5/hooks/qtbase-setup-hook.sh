qtPluginPrefix=@qtPluginPrefix@
qtQmlPrefix=@qtQmlPrefix@
qtDocPrefix=@qtDocPrefix@

. @fix_qt_builtin_paths@
. @fix_qt_module_paths@
. @fix_qt_static_libs@

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

addToQMAKEPATH() {
    if [ -d "$1/mkspecs" ]; then
        QMAKEMODULES="${QMAKEMODULES}${QMAKEMODULES:+:}/mkspecs"
        QMAKEPATH="${QMAKEPATH}${QMAKEPATH:+:}$1"
    fi
}

# Propagate any runtime dependency of the building package.
# Each dependency is propagated to the user environment and as a build
# input so that it will be re-propagated to the user environment by any
# package depending on the building package. (This is necessary in case
# the building package does not provide runtime dependencies itself and so
# would not be propagated to the user environment.)
qtEnvHook() {
    addToQMAKEPATH "$1"
    if providesQtRuntime "$1"; then
        if [ "z${!outputBin}" != "z${!outputDev}" ]; then
            propagatedBuildInputs+=" $1"
        fi
        propagatedUserEnvPkgs+=" $1"
    fi
}
if [ "$crossConfig" ]; then
   crossEnvHooks+=(qtEnvHook)
else
   envHooks+=(qtEnvHook)
fi

postPatchMkspecs() {
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
if [ -z "$dontPatchMkspecs" ]; then
    postPhases="${postPhases}${postPhases:+ }postPatchMkspecs"
fi

postMoveQtStaticLibs() {
    if [ "z${!outputLib}" != "z${!outputDev}" ]; then
        fixQtStaticLibs "${!outputLib}" "${!outputDev}"
    fi
}
if [ -z "$dontMoveQtStaticLibs" ]; then
    postPhases="${postPhases}${postPhases:+ }postMoveQtStaticLibs"
fi
