# Setup hook for pip.
echo "Sourcing pip-install-hook"

declare -a pipInstallFlags

pipInstallPhase() {
    echo "Executing pipInstallPhase"
    runHook preInstall

    mkdir -p "$out/@pythonSitePackages@"
    export PYTHONPATH="$out/@pythonSitePackages@:$PYTHONPATH"

    @pythonInterpreter@ -m pip install $pname --find-links dist --no-index --no-warn-script-location --prefix="$out" --no-cache $pipInstallFlags

    runHook postInstall
    echo "Finished executing pipInstallPhase"
}

if [ -z "${dontUsePipInstall-}" ] && [ -z "${installPhase-}" ]; then
    echo "Using pipInstallPhase"
    installPhase=pipInstallPhase
fi


pipAuditTmpdir() {
    local dir="$out/@pythonSitePackages@"

    echo "checking for references to $TMPDIR/ in $dir..."

    # OK if no files are found, or they don't have forbidden references
    if grep "$TMPDIR/" "$dir"/*/direct_url.json; then
        echo "direct_url.json contains a forbidden reference to $TMPDIR/"
        exit 1
    fi
}

if [[ -z "${noAuditTmpdir-}" ]]; then
    fixupOutputHooks+=(pipAuditTmpdir)
fi
