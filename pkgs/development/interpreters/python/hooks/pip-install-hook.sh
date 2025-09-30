# Setup hook for pip.
# shellcheck shell=bash

echo "Sourcing pip-install-hook"

pipInstallPhase() {
    echo "Executing pipInstallPhase"
    runHook preInstall

    # shellcheck disable=SC2154
    mkdir -p "$out/@pythonSitePackages@"
    export PYTHONPATH="$out/@pythonSitePackages@:$PYTHONPATH"

    local -a flagsArray=(
        --no-index
        --no-warn-script-location
        --prefix="$out"
        --no-cache
    )
    concatTo flagsArray pipInstallFlags

    pushd dist || return 1
    echoCmd 'pip install flags' "${flagsArray[@]}"
    @pythonInterpreter@ -m pip install ./*.whl "${flagsArray[@]}"
    popd || return 1

    runHook postInstall
    echo "Finished executing pipInstallPhase"
}

if [ -z "${dontUsePipInstall-}" ] && [ -z "${installPhase-}" ]; then
    echo "Using pipInstallPhase"
    installPhase=pipInstallPhase
fi
