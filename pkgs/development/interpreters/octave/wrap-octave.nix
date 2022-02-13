{ lib
, octave
, makeSetupHook
, makeWrapper
}:

# Defined in trivial-builders.nix
# Imported as wrapOctave in octave/default.nix and passed to octave's buildEnv
# as nativeBuildInput
# Each of the substitutions is available in the wrap.sh script as @thingSubstituted@
makeSetupHook {
  name = "${octave.name}-pkgs-setup-hook";
  deps = makeWrapper;
  substitutions.executable = octave.interpreter;
  substitutions.octave = octave;
} ./wrap.sh
