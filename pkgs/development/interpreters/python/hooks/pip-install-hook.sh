# Setup hook for pip.
echo "Sourcing pip-install-hook"

declare -a pipInstallFlags

pipInstallPhase() {
    echo "Executing pipInstallPhase"
    runHook preInstall

    mkdir -p "$out/@pythonSitePackages@"
    export PYTHONPATH="$out/@pythonSitePackages@:$PYTHONPATH"

    pushd dist || return 1
    @pythonInterpreter@ -m pip install ./*.whl --no-index --no-warn-script-location --prefix="$out" --no-cache $pipInstallFlags
    popd || return 1

    runHook postInstall
    echo "Finished executing pipInstallPhase"
}

if [ -z "${dontUsePipInstall-}" ] && [ -z "${installPhase-}" ]; then
    echo "Using pipInstallPhase"
    installPhase=pipInstallPhase
fi
