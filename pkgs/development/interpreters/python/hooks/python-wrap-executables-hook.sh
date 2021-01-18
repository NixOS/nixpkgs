# shellcheck shell=bash
appsWrapperArgs=()
pythonWrapperArgs=()



pythonWrapExecutablesPhase() {
    # The $pythonPath variable may be passed in 
    # from the buildPythonPackage function.
    buildPythonPath "$out $pythonPath"
    pythonWrapperArgs+=(--set PYTHONPATH )
}

if [ -z "${dontUsePythonWrapExecutables-}" ]; then
    echo "Using pythonWrapExecutablesPhase"
    preFixupPhases+=" pythonWrapExecutablesPhase"
fi
