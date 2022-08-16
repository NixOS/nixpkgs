# Setup hook to use for pip projects
echo "Sourcing pip-build-hook"

pipBuildPhase() {
    echo "Executing pipBuildPhase"
    runHook preBuild

    mkdir -p dist
    echo "Creating a wheel..."
    # HACK: there's no standard option to build in parallel
    # but the most common advice to build a given python project
    # in parallel is to set MAKEFLAGS
    # so set MAKEFLAGS so any project internally using make will do so
    # stdenv's hook only sets MAKEFLAGS while calling make in its own phases
    # so this is necessary to ensure it's set while running `pip wheel`
    MAKEFLAGS="$MAKEFLAGS${enableParallelBuilding:+ -j$NIX_BUILD_CORES -l$NIX_BUILD_CORES}" \
    @pythonInterpreter@ -m pip wheel --verbose --no-index --no-deps --no-clean --no-build-isolation --wheel-dir dist .
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
