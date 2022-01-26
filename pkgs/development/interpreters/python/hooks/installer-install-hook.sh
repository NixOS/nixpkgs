# Setup hook for installing wheels using installer
echo "Sourcing installer-install-hook"

declare -a installerInstallFlags

installerInstallPhase() {
    echo "Executing installerInstallPhase"
    runHook preInstall

    mkdir -p "$out/@pythonSitePackages@"
    export PYTHONPATH="$out/@pythonSitePackages@:$PYTHONPATH"

    pushd dist || return 1
    @pythonInterpreter@ -m install_python_wheel ./*.whl --prefix "$out" --prefix-to-remove "${python.pythonForBuild}" --compile-bytecode "0"
    popd || return 1

    runHook postInstall
    echo "Finished executing installerInstallPhase"
}

if [ -z "${dontUseInstallerInstall-}" ] && [ -z "${installPhase-}" ]; then
    echo "Using installerInstallPhase"
    installPhase=installerInstallPhase
fi
