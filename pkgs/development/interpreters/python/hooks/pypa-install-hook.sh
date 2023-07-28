# Setup hook for PyPA installer.
echo "Sourcing pypa-install-hook"

pypaInstallPhase() {
    echo "Executing pypaInstallPhase"
    runHook preInstall

    @pythonInterpreter@ -m installer --prefix "$out" dist/*.whl

    export PYTHONPATH="$out/@pythonSitePackages@:$PYTHONPATH"

    runHook postInstall
    echo "Finished executing pypaInstallPhase"
}

if [ -z "${dontUsePypaInstall-}" ] && [ -z "${installPhase-}" ]; then
    echo "Using pypaInstallPhase"
    installPhase=pypaInstallPhase
fi
