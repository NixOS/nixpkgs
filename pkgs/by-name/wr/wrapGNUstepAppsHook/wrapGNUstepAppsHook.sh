if [[ -z "${__nix_wrapGNUstepAppsHook-}" ]]; then
    __nix_wrapGNUstepAppsHook=1 # Don't run this hook more than once.

    # Inherit arguments given in mkDerivation
    gnustepWrapperArgs=(${gnustepWrapperArgs-})

    gnustepConfigVars+=(
        GNUSTEP_MAKEFILES
        NIX_GNUSTEP_SYSTEM_APPS
        NIX_GNUSTEP_SYSTEM_ADMIN_APPS
        NIX_GNUSTEP_SYSTEM_WEB_APPS
        NIX_GNUSTEP_SYSTEM_TOOLS
        NIX_GNUSTEP_SYSTEM_ADMIN_TOOLS
        NIX_GNUSTEP_SYSTEM_LIBRARY
        NIX_GNUSTEP_SYSTEM_HEADERS
        NIX_GNUSTEP_SYSTEM_LIBRARIES
        NIX_GNUSTEP_SYSTEM_DOC
        NIX_GNUSTEP_SYSTEM_DOC_MAN
        NIX_GNUSTEP_SYSTEM_DOC_INFO
    )

    wrapGNUstepApp() {
        wrapProgram "$1" \
            --set GNUSTEP_CONFIG_FILE "$out/GNUstep.conf" \
            "${gnustepWrapperArgs[@]}"
    }

    ensureGNUstepConfig() (
        if [[ -f "$out/GNUstep.conf" ]]; then
            return
        fi

        echo "writing GNUstep config file"

        gsAddToSearchPath() {
            if [[ -d "$2" && "${!1-}" != *"$2"* ]]; then
                addToSearchPath "$1" "$2"
            fi
        }

        gsAddToIncludeSearchPath() {
            local -n ref="$1"

            if [[ -d "$2" && "${ref-}" != *"$2"* ]]; then
                if [[ "${ref-}" != "" ]]; then
                    ref+=" "
                fi

                ref+="$2"
            fi
        }

        gsAddToSearchPath NIX_GNUSTEP_SYSTEM_APPS "$out/lib/GNUstep/Applications"
        gsAddToSearchPath NIX_GNUSTEP_SYSTEM_ADMIN_APPS "$out/lib/GNUstep/Applications"
        gsAddToSearchPath NIX_GNUSTEP_SYSTEM_WEB_APPS "$out/lib/GNUstep/WebApplications"
        gsAddToSearchPath NIX_GNUSTEP_SYSTEM_TOOLS "$out/bin"
        gsAddToSearchPath NIX_GNUSTEP_SYSTEM_ADMIN_TOOLS "$out/sbin"
        gsAddToSearchPath NIX_GNUSTEP_SYSTEM_LIBRARY "$out/lib/GNUstep"
        gsAddToIncludeSearchPath NIX_GNUSTEP_SYSTEM_HEADERS "$out/include"
        gsAddToSearchPath NIX_GNUSTEP_SYSTEM_LIBRARIES "$out/lib"
        gsAddToSearchPath NIX_GNUSTEP_SYSTEM_DOC "$out/share/GNUstep/Documentation"
        gsAddToSearchPath NIX_GNUSTEP_SYSTEM_DOC_MAN "$out/share/man"
        gsAddToSearchPath NIX_GNUSTEP_SYSTEM_DOC_INFO "$out/share/info"

        for var in "${gnustepConfigVars[@]}"; do
            if [[ -n "${!var-}" ]]; then
                printf '%s="%s"\n' "$var" "${!var}"
            fi
        done > "$out/GNUstep.conf"
    )

    # Note: $gnustepWrapperArgs still gets defined even if ${dontWrapGNUstepApps-} is set.
    wrapGNUstepAppsHook() {
        # skip this hook when requested
        [[ -z "${dontWrapGNUstepApps-}" ]] || return 0

        # guard against running multiple times (e.g. due to propagation)
        [[ -z "$wrapGNUstepAppsHookHasRun" ]] || return 0
        wrapGNUstepAppsHookHasRun=1

        local targetDirs=("$prefix/bin")
        echo "wrapping GNUstep applications in ${targetDirs[@]}"

        for targetDir in "${targetDirs[@]}"; do
            [[ -d "$targetDir" ]] || continue

            while IFS= read -r -d '' file; do
                ensureGNUstepConfig
                echo "wrapping $file"
                wrapGNUstepApp "$file"
            done < <(find "$targetDir" ! -type d -executable -print0)
        done
    }

    fixupOutputHooks+=(wrapGNUstepAppsHook)
fi
