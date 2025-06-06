# Setup hook for writing octave packages that are run-time dependencies for
# another package to a nix-support file.
# `echo`s the full path name to the package derivation that is required.
echo "Sourcing octave-write-required-octave-packages-hook.sh"

octaveWriteRequiredOctavePackagesPhase() {
    echo "Executing octaveWriteRequiredOctavePackagesPhase"

    mkdir -p $out/nix-support
    echo ${requiredOctavePackages} > $out/nix-support/required-octave-packages
}

# Yes its a bit long...
if [ -z "${dontWriteRequiredOctavePackagesPhase-}" ]; then
    echo "Using octaveWriteRequiredOctavePackagesPhase"
    preDistPhases+=" octaveWriteRequiredOctavePackagesPhase"
fi
