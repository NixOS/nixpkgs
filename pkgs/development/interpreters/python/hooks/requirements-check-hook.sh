# Setup hook for requirements.
echo "Sourcing requirements-check-hook"

requirementsCheckPhase() {
    if [ -z "$requirementsCheckFile" ]; then
        echo "Error: no $requirementsCheckFile was given."
        exit 1

    @pythonCheckInterpreter@ @requirementsCheckScript@ $requirementsCheckFile
}

if [ -z "$dontUseRequirementsCheck" ]; then
    echo "Using requirementsCheckPhase"
    preDistPhases+=" requirementsCheckPhase"
fi
