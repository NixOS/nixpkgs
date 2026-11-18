if [[ -z "${__nix_wrapGNUstepAppsHook-}" ]]; then
    __nix_wrapGNUstepAppsHook=1 # Don't run this hook more than once.

    # Inherit arguments given in mkDerivation
    gnustepWrapperArgs=(${gnustepWrapperArgs-})

    # NIX_GNUSTEP_SYSTEM_HEADERS is deliberately missing here: it only matters
    # while compiling and gnustep-base ignores it at run time, so writing it
    # into the installed config file would only pull the -dev outputs of every
    # build input into the runtime closure.
    gnustepConfigVars+=(
        GNUSTEP_MAKEFILES
        NIX_GNUSTEP_SYSTEM_APPS
        NIX_GNUSTEP_SYSTEM_ADMIN_APPS
        NIX_GNUSTEP_SYSTEM_WEB_APPS
        NIX_GNUSTEP_SYSTEM_TOOLS
        NIX_GNUSTEP_SYSTEM_ADMIN_TOOLS
        NIX_GNUSTEP_SYSTEM_LIBRARY
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

        # Without strictDeps, gnustep-make's environment hook also picks up
        # native build inputs, so the NIX_GNUSTEP_* paths include the compiler
        # wrapper and friends. Keeping those in the installed config file would
        # make the whole toolchain a runtime dependency (~1.6 GB).
        gsDropBuildOnlyPaths() {
            local -n pathsRef="$1"
            local -a kept=()
            local entry prefix
            local IFS=:

            for entry in ${pathsRef-}; do
                for prefix in "${gnustepRuntimePrefixes[@]}"; do
                    if [[ "$entry" =~ ^"$prefix"(/|$) ]]; then
                        kept+=("$entry")
                        break
                    fi
                done
            done

            pathsRef="${kept[*]}"
        }

        gnustepRuntimePrefixes=()

        for output in ${outputs:-out}; do
            gnustepRuntimePrefixes+=("${!output}")
        done

        for pkg in \
            ${pkgsHostHost+"${pkgsHostHost[@]}"} \
            ${pkgsHostTarget+"${pkgsHostTarget[@]}"}
        do
            gnustepRuntimePrefixes+=("$pkg")
        done

        gsAddToSearchPath NIX_GNUSTEP_SYSTEM_APPS "$out/lib/GNUstep/Applications"
        gsAddToSearchPath NIX_GNUSTEP_SYSTEM_ADMIN_APPS "$out/lib/GNUstep/Applications"
        gsAddToSearchPath NIX_GNUSTEP_SYSTEM_WEB_APPS "$out/lib/GNUstep/WebApplications"
        gsAddToSearchPath NIX_GNUSTEP_SYSTEM_TOOLS "$out/bin"
        gsAddToSearchPath NIX_GNUSTEP_SYSTEM_ADMIN_TOOLS "$out/sbin"
        gsAddToSearchPath NIX_GNUSTEP_SYSTEM_LIBRARY "$out/lib/GNUstep"
        gsAddToSearchPath NIX_GNUSTEP_SYSTEM_LIBRARIES "$out/lib"
        gsAddToSearchPath NIX_GNUSTEP_SYSTEM_DOC "$out/share/GNUstep/Documentation"
        gsAddToSearchPath NIX_GNUSTEP_SYSTEM_DOC_MAN "$out/share/man"
        gsAddToSearchPath NIX_GNUSTEP_SYSTEM_DOC_INFO "$out/share/info"

        for var in "${gnustepConfigVars[@]}"; do
            # GNUSTEP_MAKEFILES is a single path pointing at gnustep-make
            # rather than a search path assembled from the build environment.
            [[ "$var" == NIX_GNUSTEP_* ]] || continue
            gsDropBuildOnlyPaths "$var"
        done

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
