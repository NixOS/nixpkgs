if [[ -z "${__nix_wrapQtAppsHook-}" ]]; then
    __nix_wrapQtAppsHook=1 # Don't run this hook more than once.

    # Inherit arguments given in mkDerivation
    qtWrapperArgs=(${qtWrapperArgs-})

    qtHostPathSeen=()

    qtUnseenHostPath() {
        for pkg in "${qtHostPathSeen[@]}"; do
            if [ "${pkg:?}" == "$1" ]; then
                return 1
            fi
        done

        qtHostPathSeen+=("$1")
        return 0
    }

    qtHostPathHook() {
        qtUnseenHostPath "$1" || return 0

        if ! [ -v qtPluginPrefix ]; then
            echo "wrapQtAppsHook qtHostPathHook: qtPluginPrefix is unset. hint: add qt6.qtbase to buildInputs"
        fi

        local pluginDir="$1/${qtPluginPrefix:?}"
        if [ -d "$pluginDir" ]; then
            qtWrapperArgs+=(--prefix QT_PLUGIN_PATH : "$pluginDir")
        fi

        local qmlDir="$1/${qtQmlPrefix:?}"
        if [ -d "$qmlDir" ]; then
            qtWrapperArgs+=(--prefix NIXPKGS_QT6_QML_IMPORT_PATH : "$qmlDir")
        fi
    }
    addEnvHooks "$targetOffset" qtHostPathHook

    makeQtWrapper() {
        local original="$1"
        local wrapper="$2"
        shift 2
        makeWrapper "$original" "$wrapper" "${qtWrapperArgs[@]}" "$@"
    }

    wrapQtApp() {
        local program="$1"
        shift 1
        wrapProgram "$program" "${qtWrapperArgs[@]}" "$@"
    }

    qtOwnPathsHook() {
        local xdgDataDir="${!outputBin}/share"
        if [ -d "$xdgDataDir" ]; then
            qtWrapperArgs+=(--prefix XDG_DATA_DIRS : "$xdgDataDir")
        fi

        local xdgConfigDir="${!outputBin}/etc/xdg"
        if [ -d "$xdgConfigDir" ]; then
            qtWrapperArgs+=(--prefix XDG_CONFIG_DIRS : "$xdgConfigDir")
        fi

        qtHostPathHook "${!outputBin}"
    }

    appendToVar preFixupPhases qtOwnPathsHook

    # Note: $qtWrapperArgs still gets defined even if ${dontWrapQtApps-} is set.
    wrapQtAppsHook() {
        # skip this hook when requested
        [ -z "${dontWrapQtApps-}" ] || return 0

        # guard against running multiple times (e.g. due to propagation)
        [ -z "$wrapQtAppsHookHasRun" ] || return 0
        wrapQtAppsHookHasRun=1

        local targetDirs=("$prefix/bin" "$prefix/sbin" "$prefix/libexec" "$prefix/Applications" "$prefix/"*.app)
        echo "wrapping Qt applications in ${targetDirs[@]}"

        for targetDir in "${targetDirs[@]}"; do
            [ -d "$targetDir" ] || continue

            find "$targetDir" ! -type d -executable -print0 | while IFS= read -r -d '' file; do
                # Skip the file if it is not a binary (ELF or Mach-O)
                isELF "$file" || isMachO "$file" || continue

                if [ -h "$file" ]; then
                    target="$(readlink -e "$file")"
                    echo "wrapping $file -> $target"
                    rm "$file"
                    makeQtWrapper "$target" "$file"
                elif [ -f "$file" ]; then
                    echo "wrapping $file"
                    wrapQtApp "$file"
                fi
            done
        done
    }

    fixupOutputHooks+=(wrapQtAppsHook)

fi
