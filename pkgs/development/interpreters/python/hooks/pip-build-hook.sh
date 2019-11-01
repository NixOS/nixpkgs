# Setup hook to use for pip projects
echo "Sourcing pip-build-hook"

pipBuildPhase() {
    echo "Executing pipBuildPhase"
    runHook preBuild

    mkdir -p dist
    echo "Creating a wheel..."
    @pythonInterpreter@ -m pip wheel --no-index --no-deps --no-clean --no-build-isolation --wheel-dir dist .
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
      @pythonInterpreter@ -m pip install -e . --prefix "$tmp_path" >&2
    fi

    runHook postShellHook
    echo "Finished executing pipShellHook"
}

if [ -z "$dontUsePipBuild" ] && [ -z "$buildPhase" ]; then
    echo "Using pipBuildPhase"
    buildPhase=pipBuildPhase
fi

if [ -z "$shellHook" ]; then
    echo "Using pipShellHook"
    shellHook=pipShellHook
fi
