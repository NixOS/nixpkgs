# Setup hook for storing dist folder (wheels/sdists) in a separate output
echo "Sourcing python-catch-conflicts-hook.sh"

pythonOutputDistPhase() {
    echo "Executing pythonOutputDistPhase"
    mv "dist" "$dist"
    echo "Finished executing pythonOutputDistPhase"
}

preFixupPhases+=" pythonOutputDistPhase"
