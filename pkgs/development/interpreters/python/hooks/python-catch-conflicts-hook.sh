# Setup hook for detecting conflicts in Python packages
echo "Sourcing python-catch-conflicts-hook.sh"

pythonCatchConflictsPhase() {
    @pythonInterpreter@ @catchConflicts@
}

if [ -z "$dontUsePythonCatchConflicts" ]; then
    preDistPhases+=" pythonCatchConflictsPhase"
fi
