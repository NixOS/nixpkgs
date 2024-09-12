# Setup hook for relaxing build-system.requires constraints
echo "Sourcing relax-build-system-requires-hook"

relaxBuildSystemRequiresHook() {
    echo "Executing relaxBuildSystemRequires"

    echo "Relaxing build-system requires"
    export PYTHONPATH=$PYTHONPATH:@hookdir@
    @pythonInterpreter@ @hook@

    echo "Finished executing relaxBuildSystemRequires"
}

echo "Using relaxBuildSystemRequiresHook"
preBuildPhases+=" relaxBuildSystemRequiresHook"
