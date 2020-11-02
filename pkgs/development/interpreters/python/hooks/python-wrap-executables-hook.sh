# Wrap (and patch) Python executables

pythonWrapExecutablesPhase() {
    wrapPythonPrograms
}

if [ -z "${dontUsePythonWrapExecutables-}" ]; then
    echo "Using pythonWrapExecutablesPhase"
    preFixupPhases+=" pythonWrapExecutablesPhase"
fi
