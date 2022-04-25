# shellcheck shell=bash

# Setup hook that fixes Python dependencies versions.
#
# Example usage in a derivation:
#
#   { …, pythonPackages, … }:
#
#   pythonPackages.buildPythonPackage {
#     …
#     nativeBuildInputs = [ pythonPackages.setuptoolsDepsVersionsHook ];
#
#     # Location of the requirements.txt file, supports Python's glob
#     # Defaults to `**/requirements*.txt`
#     requirementsTxt = "requirements_*.txt";
#
#     # This will relax the dependency restrictions
#     # e.g.: abc>1,<=2 -> abc
#     relaxPythonDeps = [ "abc" ];
#     # This will relax all dependencies restrictions instead
#     # relaxPythonDeps = true;
#     # This will remove the dependency
#     # e.g.: cde>1,<=2 -> <nothing>
#     removePythonDeps = [ "cde" ];
#     # This will remove all dependencies from the project
#     # removePythonDeps = true;
#     …
#   }

setuptoolsDepsVersionsHook() {
    echo "Executing setuptoolsDepsVersionsHook"

    # Exporting env vars so the Python interpreter can see them
    export requirementsTxt relaxPythonDeps removePythonDeps NIX_DEBUG
    @pythonInterpreter@ @setuptoolsRequirementsTxtDepsVersionsHookPy@
}

preBuild+=" setuptoolsDepsVersionsHook"
