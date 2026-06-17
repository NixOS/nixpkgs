# shellcheck shell=bash

# Setup hook for checking whether metadata in .dist-info matches the derivation
echo "Sourcing python-metadata-check-hook.sh"

versionCompareScript=$(cat << EOM
from packaging.version import Version
from sys import argv
assert Version(argv[2]) == Version(argv[3]), \
  f"The '{argv[1]}' derivation has version '{argv[2]}' but .dist-info/METADATA specifies version '{argv[3]}'."
EOM
)

pythonMetadataCheckPhase() {
  echo "Executing pythonMetadataCheckPhase"

  # shellcheck disable=SC2154
  pythonMetadataCheckOutput="$out"
  if [[ -n "${python-}" ]]; then
    echo "Using python specific output \$python for metadata check"
    pythonMetadataCheckOutput=$python
  fi
  # shellcheck disable=SC2154
  derivationPname="$pname"
  # shellcheck disable=SC2154
  derivationVersion="$version"
  # `python -P` avoids picking up egg-info dirs in $PWD
  metadataVersion="$(PYTHONPATH="$pythonMetadataCheckOutput/@pythonSitePackages@:$PYTHONPATH" \
    @pythonInterpreter@ -P -c 'from importlib.metadata import version; import sys; print(version(sys.argv[1]))' "$derivationPname")"
  @pythonWithPackaging@ -c "$versionCompareScript" "$derivationPname" "$derivationVersion" "$metadataVersion"
}

if [ -z "${dontCheckPythonMetadata-}" ]; then
    echo "Using pythonMetadataCheckPhase"
    appendToVar preDistPhases pythonMetadataCheckPhase
fi
