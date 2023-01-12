# Setup hook for detecting conflicts in Python packages
echo "Sourcing python-catch-conflicts-hook.sh"

pythonCatchConflictsPhase() {
    PYTHONPATH="@setuptools@/@pythonSitePackages@:$PYTHONPATH" @pythonInterpreter@ @catchConflicts@
}

if [ -z "${dontUsePythonCatchConflicts-}" ]; then
    addPhase "preDistPhases pythonCatchConflictsPhase"
fi
