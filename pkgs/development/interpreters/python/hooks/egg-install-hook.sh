# Setup hook for eggs
echo "Sourcing egg-install-hook"

eggInstallPhase() {
    echo "Executing eggInstallPhase"
    runHook preInstall

    mkdir -p "$out/@pythonSitePackages@"
    export PYTHONPATH="$out/@pythonSitePackages@:$PYTHONPATH"

    find
    @pythonInterpreter@ -m easy_install --prefix="$out" *.egg

    runHook postInstall
    echo "Finished executing eggInstallPhase"
}

if [ -z "${dontUseEggInstall-}" ] && [ -z "${installPhase-}" ]; then
    echo "Using eggInstallPhase"
    installPhase=eggInstallPhase
fi
