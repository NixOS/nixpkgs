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
    @pythonInterpreter@ -P -c 'from importlib.metadata import version; import sys; print(version(sys.argv[1]))' "$derivationPname")"

  # check that both versions can be parsed
  @pythonWithPackaging@ -c "from packaging.version import Version; from sys import argv; Version(argv[1]); Version(argv[2])" "$derivationVersion" "$metadataVersion"

  if @pythonWithPackaging@ -c "from packaging.version import Version; from sys import argv, exit; exit(Version(argv[1]) == Version(argv[2]))" "$derivationVersion" "$metadataVersion"; then
    echo "The '$derivationPname' derivation has version '$derivationVersion' but .dist-info/METADATA specifies version '$metadataVersion'."
    echo "This usually means that the wrong version is hardcoded in pyproject.toml or setup.{py,cfg}."
    echo "Use the pyprojectVersionPatchHook or patch the version manually so that the project metadata matches the derivation's version."
    exit 1
  fi
}

if [ -z "${dontCheckPythonMetadata-}" ]; then
    echo "Using pythonMetadataCheckPhase"
    appendToVar preDistPhases pythonMetadataCheckPhase
fi
