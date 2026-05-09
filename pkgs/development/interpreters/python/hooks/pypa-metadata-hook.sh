# Setup hook to generate PyPA metadata
# shellcheck shell=bash

echo "Sourcing pypa-metadata-hook"

pypaMetadataPhase() {
  echo "Generate dist-info metadata"
  @pythonInterpreter@ @generateMetadata@ $src/pyproject.toml $out/@pythonSitePackages@
}

if [ -z "${dontUsePypaMetadata-}" ]; then
    echo "Using pypaMetadataPhase"
    appendToVar preInstallPhases pypaMetadataPhase
fi
