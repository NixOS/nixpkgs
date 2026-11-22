# shellcheck shell=bash

echo "Sourcing pyproject-version-patch-hook.sh"

pyprojectVersionPatchPhase() {
  echo "Executing pyprojectVersionPatchPhase"

  # shellcheck disable=SC2154
  @pythonInterpreter@ @script@ "$version"

  echo "Finished executing pyprojectVersionPatchPhase"
}

postPatchHooks+=(pyprojectVersionPatchPhase)
