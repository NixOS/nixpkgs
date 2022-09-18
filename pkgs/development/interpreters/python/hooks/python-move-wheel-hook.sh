# Setup hook for moving wheel to an output.
echo "Sourcing python-move-wheel-hook.sh"

pythonMoveWheelPhase () {
    mkdir -p "$wheel"
    mv dist/ $wheel
}

if [ -z "${dontUsePythonMoveWheel-}" ]; then
    preDistPhases+=" pythonMoveWheelPhase"
fi
