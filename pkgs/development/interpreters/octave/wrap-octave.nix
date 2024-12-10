{
  lib,
  octave,
  makeSetupHook,
  makeWrapper,
}:

# Defined in trivial-builders
# Imported as wrapOctave in octave/default.nix and passed to octave's buildEnv
# as nativeBuildInput
# Each of the substitutions is available in the wrap.sh script as @thingSubstituted@
makeSetupHook {
  name = "${octave.name}-pkgs-setup-hook";
  propagatedBuildInputs = [ makeWrapper ];
  substitutions.executable = octave.interpreter;
  substitutions.octave = octave;
} ./wrap.sh
