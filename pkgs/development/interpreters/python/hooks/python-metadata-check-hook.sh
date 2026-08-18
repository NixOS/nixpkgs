# shellcheck shell=bash

# Setup hook for checking whether metadata in .dist-info matches the derivation
echo "Sourcing python-metadata-check-hook.sh"

pythonMetadataCheckPhase() {
  echo "Executing pythonMetadataCheckPhase"

  # shellcheck disable=SC2154
  local pythonMetadataCheckOutput="$out"
  if [[ -n "${python-}" ]]; then
    echo "Using python specific output \$python for metadata check"
    pythonMetadataCheckOutput=$python
  fi
  # shellcheck disable=SC2154
  local derivationPname="$pname"
  # shellcheck disable=SC2154
  local derivationVersion="$version"
  # `python -P` avoids picking up egg-info dirs in $PWD
  local metadataVersion
  metadataVersion="$(PYTHONPATH="$pythonMetadataCheckOutput/@pythonSitePackages@:$PYTHONPATH" \
    @pythonInterpreter@ -P @retrieveMetadata@ "$derivationPname")"

  @pythonWithPackaging@ @compareMetadata@ "$derivationPname" "$derivationVersion" "$metadataVersion"
}

if [ -z "${dontCheckPythonMetadata-}" ]; then
    echo "Using pythonMetadataCheckPhase"
    appendToVar preDistPhases pythonMetadataCheckPhase
fi
