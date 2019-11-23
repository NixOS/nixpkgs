# Setup hook for flit
echo "Sourcing flit-build-hook"

flitBuildPhase () {
    echo "Executing flitBuildPhase"
    runHook preBuild
    @pythonInterpreter@ -m flit build --format wheel
    runHook postBuild
    echo "Finished executing flitBuildPhase"
}

if [ -z "$dontUseFlitBuild" ] && [ -z "$buildPhase" ]; then
    echo "Using flitBuildPhase"
    buildPhase=flitBuildPhase
fi
