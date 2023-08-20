# Setup hook for PyPA installer.
echo "Sourcing pypa-install-hook"

pypaInstallPhase() {
    echo "Executing pypaInstallPhase"
    runHook preInstall

    for wheel in dist/*.whl; do
        @pythonInterpreter@ -m installer --prefix "$out" "$wheel"
    done

    export PYTHONPATH="$out/@pythonSitePackages@:$PYTHONPATH"

    runHook postInstall
    echo "Finished executing pypaInstallPhase"
}

if [ -z "${dontUsePypaInstall-}" ] && [ -z "${installPhase-}" ]; then
    echo "Using pypaInstallPhase"
    installPhase=pypaInstallPhase
fi
