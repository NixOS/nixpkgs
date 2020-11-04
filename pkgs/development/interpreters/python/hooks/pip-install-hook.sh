# Setup hook for pip.
echo "Sourcing pip-install-hook"

declare -a pipInstallFlags

pipInstallPhase() {
    echo "Executing pipInstallPhase"
    runHook preInstall

    mkdir -p "$out/@pythonSitePackages@"
    export PYTHONPATH="$out/@pythonSitePackages@:$PYTHONPATH"

    pushd dist || return 1
    mkdir tmpbuild
    NIX_PIP_INSTALL_TMPDIR=tmpbuild @pythonInterpreter@ -m pip install ./*.whl --no-index --prefix="$out" --no-cache $pipInstallFlags
    rm -rf tmpbuild
    popd || return 1

    runHook postInstall
    echo "Finished executing pipInstallPhase"
}

if [ -z "${dontUsePipInstall-}" ] && [ -z "${installPhase-}" ]; then
    echo "Using pipInstallPhase"
    installPhase=pipInstallPhase
fi
