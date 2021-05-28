# Setup hook for setuptools.
echo "Sourcing setuptools-build-hook"

setuptoolsBuildPhase() {
    echo "Executing setuptoolsBuildPhase"
    local args
    runHook preBuild

    cp -f @setuppy@ nix_run_setup
    args=""
    if [ -n "$setupPyGlobalFlags" ]; then
        args+="$setupPyGlobalFlags"
    fi
    if [ -n "$setupPyBuildFlags" ]; then
        args+="build_ext $setupPyBuildFlags"
    fi
    eval "@pythonInterpreter@ nix_run_setup $args bdist_wheel"

    runHook postBuild
    echo "Finished executing setuptoolsBuildPhase"
}

setuptoolsShellHook() {
    echo "Executing setuptoolsShellHook"
    runHook preShellHook

    if test -e setup.py; then
        tmp_path=$(mktemp -d)
        export PATH="$tmp_path/bin:$PATH"
        export PYTHONPATH="$tmp_path/@pythonSitePackages@:$PYTHONPATH"
        mkdir -p "$tmp_path/@pythonSitePackages@"
        eval "@pythonInterpreter@ -m pip install -e . --prefix $tmp_path \
          --no-build-isolation >&2"
    fi

    runHook postShellHook
    echo "Finished executing setuptoolsShellHook"
}

if [ -z "${dontUseSetuptoolsBuild-}" ] && [ -z "${buildPhase-}" ]; then
    echo "Using setuptoolsBuildPhase"
    buildPhase=setuptoolsBuildPhase
fi

if [ -z "${dontUseSetuptoolsShellHook-}" ] && [ -z "${shellHook-}" ]; then
    echo "Using setuptoolsShellHook"
    shellHook=setuptoolsShellHook
fi
