# Setup hook for pip.
# shellcheck shell=bash

echo "Sourcing pip-install-hook"

pipInstallPhase() {
    echo "Executing pipInstallPhase"
    runHook preInstall

    # shellcheck disable=2154
    mkdir -p "$out/@pythonSitePackages@"
    export PYTHONPATH="$out/@pythonSitePackages@:$PYTHONPATH"

    # ShellCheck seems unable to parse nameref used to implement concatTo.
    # shellcheck disable=2034
    declare -a defaultPipInstallFlags=(
        --no-index
        --no-warn-script-location
        --prefix="$out"
        --no-cache
    )

    local -a flagsArray
    concatTo flagsArray defaultPipInstallFlags pipInstallFlags

    pushd dist || return 1
    @pythonInterpreter@ -m pip install ./*.whl "${flagsArray[@]}"
    popd || return 1

    unset flagsArray

    runHook postInstall
    echo "Finished executing pipInstallPhase"
}

if [ -z "${dontUsePipInstall-}" ] && [ -z "${installPhase-}" ]; then
    echo "Using pipInstallPhase"
    installPhase=pipInstallPhase
fi
