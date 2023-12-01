# Setup hook for writing octave packages that are run-time dependencies for
# another package to a nix-support file.
# `echo`s the full path name to the package derivation that is required.
echo "Sourcing write-required-octave-packages-hook.sh"

writeRequiredOctavePackagesPhase() {
    echo "Executing writeRequiredOctavePackagesPhase"

    mkdir -p $out/nix-support
    echo ${requiredOctavePackages} > $out/nix-support/required-octave-packages
}

# Yes its a bit long...
if [ -z "${dontWriteRequiredOctavePackagesPhase-}" ]; then
    echo "Using writeRequiredOctavePackagesPhase"
    preDistPhases+=" writeRequiredOctavePackagesPhase"
fi
