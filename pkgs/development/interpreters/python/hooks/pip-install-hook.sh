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

    # Some wheels ship .py files inside their dist-info (e.g. av carries
    # licenses/AUTHORS.py); pip byte-compiles those too, embedding the
    # package's own store path in bytecode inside its metadata.
    for metadata in "$out"/@pythonSitePackages@/*.dist-info; do
        [ -d "$metadata" ] || continue
        find "$metadata" -name '__pycache__' -type d -prune -exec rm -rf {} +
    done

    runHook postInstall
    echo "Finished executing pipInstallPhase"
}

if [ -z "${dontUsePipInstall-}" ] && [ -z "${installPhase-}" ]; then
    echo "Using pipInstallPhase"
    installPhase=pipInstallPhase
fi
