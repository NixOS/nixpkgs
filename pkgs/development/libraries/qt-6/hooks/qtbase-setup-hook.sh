if [[ -n "${__nix_qt_skip_setup-}" ]]; then return; fi

if [[ -n "@qtCrossBuild@" ]]; then
    export __nix_qt_crossbuild=1
    declare -n __nix_qtbase_check=__nix_qtbase_cross
else
    declare -n __nix_qtbase_check=__nix_qtbase
fi

if [[ -n "${__nix_qtbase-}" ]]; then
    # Throw an error if a different version of Qt was already set up.

    if [[ -n "${__nix_qtbase_check-}" && "${__nix_qtbase_check}" != "@out@" ]]; then
        echo >&2 "Error: detected mismatched Qt dependencies:"
        echo >&2 "    @out@"
        echo >&2 "    $__nix_qtbase_check"
        exit 1
    fi
else # Only set up Qt once.
    qtPluginPrefix=@qtPluginPrefix@
    qtQmlPrefix=@qtQmlPrefix@

    . @fix_qt_builtin_paths@
    . @fix_qt_module_paths@

    # Build tools are often confused if QMAKE is unset.
    export QMAKE=@out@/bin/qmake

    export QMAKEPATH=

    export QMAKEMODULES=

    declare -Ag qmakePathSeen=()
    qmakePathHook() {
        # Skip this path if we have seen it before.
        # MUST use 'if' because 'qmakePathSeen[$]' may be unset.
        if [ -n "${qmakePathSeen[$1]-}" ]; then return; fi
        qmakePathSeen[$1]=1
        if [ -d "$1/mkspecs" ]; then
            QMAKEMODULES="${QMAKEMODULES}${QMAKEMODULES:+:}/mkspecs"
            QMAKEPATH="${QMAKEPATH}${QMAKEPATH:+:}$1"
        fi
    }
    envBuildHostHooks+=(qmakePathHook)

    postPatchMkspecs() {
        # Prevent this hook from running multiple times
        dontPatchMkspecs=1

        local lib="${!outputLib}"
        local dev="${!outputDev}"

        moveToOutput "mkspecs/modules" "$dev"

        if [ -d "$dev/mkspecs/modules" ]; then
            fixQtModulePaths "$dev/mkspecs/modules"
        fi

        if [ -d "$lib/mkspecs" ]; then
            fixQtBuiltinPaths "$lib/mkspecs" '*.pr?'
        fi

        if [ -d "$lib/lib" ]; then
            fixQtBuiltinPaths "$lib/lib" '*.pr?'
        fi
    }
    if [ -z "${dontPatchMkspecs-}" ]; then
        appendToVar postPhases postPatchMkspecs
    fi

    qtPreHook() {
        # Check that wrapQtAppsHook/wrapQtAppsNoGuiHook is used, or it is explicitly disabled.
        if [[ -z "$__nix_wrapQtAppsHook" && -z "$dontWrapQtApps" ]]; then
            echo >&2 "Error: this derivation depends on qtbase, but no wrapping behavior was specified."
            echo >&2 "  - If this is a graphical application, add wrapQtAppsHook to nativeBuildInputs"
            echo >&2 "  - If this is a CLI application, add wrapQtAppsNoGuiHook to nativeBuildInputs"
            echo >&2 "  - If this is a library or you need custom wrapping logic, set dontWrapQtApps = true"
            exit 1
        fi
    }
    appendToVar prePhases qtPreHook
fi

__nix_qtbase_check="@out@"

declare -g qttoolsPathSeen=
qtToolsHook() {
    # If cross building, only QtTools versions executable on the build host should be considered.
    if [[ -n "${__nix_qt_crossbuild-}" && "${depHostOffset}" -ge 0 ]]; then return; fi

    if [ -f "$1/libexec/qhelpgenerator" ]; then
        if [[ -n "${qtToolsPathSeen:-}" && "${qttoolsPathSeen:-}" != "$1" ]]; then
            echo >&2 "Error: detected mismatched Qt dependencies:"
            echo >&2 "    $1"
            echo >&2 "    $qttoolsPathSeen"
            exit 1
        fi

        qttoolsPathSeen=$1
        appendToVar cmakeFlags "-DQT_OPTIONAL_TOOLS_PATH=$1"
    fi
}
addEnvHooks "$hostOffset" qtToolsHook

addQtModulePrefix() {
    if [[ -z "${__nix_qt_crossbuild-}" || "$depHostOffset" -ge 0 ]]; then
        addToSearchPath QT_ADDITIONAL_PACKAGES_PREFIX_PATH "$1"
    else
        addToSearchPath QT_ADDITIONAL_HOST_PACKAGES_PREFIX_PATH "$1"
    fi
}
addEnvHooks "$hostOffset" addQtModulePrefix
