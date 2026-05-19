# Setup hook to use in case a conda binary package is installed
echo "Sourcing conda install hook"

condaInstallPhase() {
    echo "Executing condaInstallPhase"
    runHook preInstall

    # There are two different formats of conda packages.
    # It either contains only a site-packages directory
    # or multiple top level directories.
    siteDir=@pythonSitePackages@
    if [ -e ./site-packages ]; then
        mkdir -p $out/$siteDir
        cp -r ./site-packages/* $out/$siteDir
    else
        cp -r . $out
        rm $out/env-vars
    fi

    runHook postInstall
    echo "Finished executing condaInstallPhase"
}

if [ -z "${installPhase-}" ]; then
    echo "Using condaInstallPhase"
    installPhase=condaInstallPhase
fi
