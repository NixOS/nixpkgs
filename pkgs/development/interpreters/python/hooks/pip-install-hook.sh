# Setup hook for pip.
echo "Sourcing pip-install-hook"

declare -a pipInstallFlags

pipInstallPhase() {
    echo "Executing pipInstallPhase"
    runHook preInstall

    mkdir -p "$out/@pythonSitePackages@"
    export PYTHONPATH="$out/@pythonSitePackages@:$PYTHONPATH"
    local _wheelPname="${wheelPname-$pname}"

    if ! @pythonInterpreter@ -m pip install "${_wheelPname}" --find-links dist --no-index --no-warn-script-location --prefix="$out" --no-cache $pipInstallFlags; then
        echo "Pip install failed, probably because no wheel was found. Change pname or add wheelPname."
        echo "Current value: $_wheelPname. Available wheels: $(ls dist)"
        exit 1
    fi

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
