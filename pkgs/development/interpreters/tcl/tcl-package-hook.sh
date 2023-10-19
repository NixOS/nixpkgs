# This hook ensures that we do the following in post-fixup:
# * wrap any installed executables with a wrapper that configures TCLLIBPATH
# * write a setup hook that extends the TCLLIBPATH of any anti-dependencies

tclWrapperArgs=( ${tclWrapperArgs-} )

# Add a directory to TCLLIBPATH, provided that it exists
_addToTclLibPath() {
    local tclPkg="$1"
    if [[ -z "$tclPkg" ]]; then
        return
    fi

    if [[ ! -d "$tclPkg" ]]; then
        >&2 echo "can't add $tclPkg to TCLLIBPATH; that directory doesn't exist"
        exit 1
    fi

    if [[ "$tclPkg" == *" "* ]]; then
        tclPkg="{$tclPkg}"
    fi

    if [[ -z "${TCLLIBPATH-}" ]]; then
        export TCLLIBPATH="$tclPkg"
    else
        if [[ "$TCLLIBPATH" != *"$tclPkg "* && "$TCLLIBPATH" != *"$tclPkg" ]]; then
            export TCLLIBPATH="${TCLLIBPATH} $tclPkg"
        fi
    fi
}

# Locate any directory containing an installed pkgIndex file
findInstalledTclPkgs() {
    local -r newLibDir="${!outputLib}/lib"
    if [[ ! -d "$newLibDir" ]]; then
        >&2 echo "Assuming no loadable tcl packages installed ($newLibDir does not exist)"
        return
    fi
    echo "$(find "$newLibDir" -name pkgIndex.tcl -exec dirname {} \;)"
}

# Wrap any freshly-installed binaries and set up their TCLLIBPATH
wrapTclBins() {
    if [ "$dontWrapTclBinaries" ]; then return; fi

    if [[ -z "${TCLLIBPATH-}" ]]; then
        echo "skipping automatic Tcl binary wrapping (nothing to do)"
        return
    fi

    local -r tclBinsDir="${!outputBin}/bin"
    if [[ ! -d "$tclBinsDir" ]]; then
        echo "No outputBin found, not using any TCLLIBPATH wrapper"
        return
    fi

    tclWrapperArgs+=(--prefix TCLLIBPATH ' ' "$TCLLIBPATH")

    find "$tclBinsDir" -type f -executable -print |
        while read -r someBin; do
            echo "Adding TCLLIBPATH wrapper for $someBin"
            wrapProgram "$someBin" "${tclWrapperArgs[@]}"
        done
}

# Generate hook to adjust TCLLIBPATH in anti-dependencies
writeTclLibPathHook() {
    local -r hookPath="${!outputLib}/nix-support/setup-hook"
    mkdir -p "$(dirname "$hookPath")"

    typeset -f _addToTclLibPath >> "$hookPath"
    local -r tclPkgs=$(findInstalledTclPkgs)
    while IFS= read -r tclPkg; do
        echo "_addToTclLibPath \"$tclPkg\"" >> "$hookPath"
        _addToTclLibPath "$tclPkg" true
    done <<< "$tclPkgs"
}

postFixupHooks+=(writeTclLibPathHook)
postFixupHooks+=(wrapTclBins)
