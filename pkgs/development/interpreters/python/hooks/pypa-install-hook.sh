# Setup hook for PyPA installer.
echo "Sourcing pypa-install-hook"

pypaInstallPhase() {
    echo "Executing pypaInstallPhase"
    runHook preInstall

    pushd dist >/dev/null

    for wheel in *.whl; do
        @pythonInterpreter@ -m installer --prefix "$out" --executable "@python@" "$wheel"
        echo "Successfully installed $wheel"
    done

    popd >/dev/null

    # Some wheels ship .py files inside their dist-info (e.g. av carries
    # licenses/AUTHORS.py); installer byte-compiles those too, embedding
    # the package's own store path in bytecode inside its metadata.
    for metadata in "$out"/@pythonSitePackages@/*.dist-info; do
        [ -d "$metadata" ] || continue
        find "$metadata" -name '__pycache__' -type d -prune -exec rm -rf {} +
    done

    export PYTHONPATH="$out/@pythonSitePackages@:$PYTHONPATH"

    runHook postInstall
    echo "Finished executing pypaInstallPhase"
}

if [ -z "${dontUsePypaInstall-}" ] && [ -z "${installPhase-}" ]; then
    echo "Using pypaInstallPhase"
    installPhase=pypaInstallPhase
fi
