# Setup hook for PyPA installer.
echo "Sourcing pypa-install-hook"

pypaInstallPhase() {
    echo "Executing pypaInstallPhase"
    runHook preInstall

    pushd dist > /dev/null

    for wheel in *.whl; do
        @pythonInterpreter@ -m installer --prefix "$out" "$wheel"
        echo "Successfully installed $wheel"
    done

    popd > /dev/null

    export PYTHONPATH="$out/@pythonSitePackages@:$PYTHONPATH"

    runHook postInstall
    echo "Finished executing pypaInstallPhase"
}

if [ -z "${dontUsePypaInstall-}" ] && [ -z "${installPhase-}" ]; then
    echo "Using pypaInstallPhase"
    installPhase=pypaInstallPhase
fi
