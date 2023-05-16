# Setup hook to use for pip projects
echo "Sourcing pip-build-hook"

<<<<<<< HEAD
declare -a pipBuildFlags

=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
pipBuildPhase() {
    echo "Executing pipBuildPhase"
    runHook preBuild

    mkdir -p dist
    echo "Creating a wheel..."
<<<<<<< HEAD
    @pythonInterpreter@ -m pip wheel \
       --verbose \
       --no-index \
       --no-deps \
       --no-clean \
       --no-build-isolation \
       --wheel-dir dist \
       $pipBuildFlags .
=======
    @pythonInterpreter@ -m pip wheel --verbose --no-index --no-deps --no-clean --no-build-isolation --wheel-dir dist .
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    echo "Finished creating a wheel..."

    runHook postBuild
    echo "Finished executing pipBuildPhase"
}

pipShellHook() {
    echo "Executing pipShellHook"
    runHook preShellHook

    # Long-term setup.py should be dropped.
    if [ -e pyproject.toml ]; then
      tmp_path=$(mktemp -d)
      export PATH="$tmp_path/bin:$PATH"
      export PYTHONPATH="$tmp_path/@pythonSitePackages@:$PYTHONPATH"
      mkdir -p "$tmp_path/@pythonSitePackages@"
      @pythonInterpreter@ -m pip install -e . --prefix "$tmp_path" \
         --no-build-isolation >&2
    fi

    runHook postShellHook
    echo "Finished executing pipShellHook"
}

if [ -z "${dontUsePipBuild-}" ] && [ -z "${buildPhase-}" ]; then
    echo "Using pipBuildPhase"
    buildPhase=pipBuildPhase
fi

if [ -z "${shellHook-}" ]; then
    echo "Using pipShellHook"
    shellHook=pipShellHook
fi
