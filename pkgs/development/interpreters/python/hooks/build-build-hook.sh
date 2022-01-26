# Setup hook to build Python projects using bootstrapped-build
echo "Sourcing build-build-hook"

pipBuildPhase() {
    echo "Executing buildBuildPhase"
    runHook preBuild

    mkdir -p dist
    echo "Building a wheel..."
    @pythonInterpreter@ -m build --wheel --no-isolation --wheel-dir dist .
    echo "Finished building a wheel..."

    runHook postBuild
    echo "Finished executing buildBuildPhase"
}

if [ -z "${dontUseBuildBuild-}" ] && [ -z "${buildPhase-}" ]; then
    echo "Using buildBuildPhase"
    buildPhase=buildBuildPhase
fi
