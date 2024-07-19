{
  lib,
  writers,
  runCommand,
}:
{
  feature ? "cuda",
  name ? feature,
  libraries ? [ ],
}:
content:

let
  tester = writers.writePython3Bin "tester-${name}" { inherit libraries; } content;
  tester' = tester.overrideAttrs (oldAttrs: {
    passthru.gpuCheck =
      runCommand "test-${name}"
        {
          nativeBuildInputs = [ tester' ];
          requiredSystemFeatures = [ feature ];
        }
        ''
          set -e
          ${tester.meta.mainProgram or (lib.getName tester')}
          touch $out
        '';
  });
in
tester'
