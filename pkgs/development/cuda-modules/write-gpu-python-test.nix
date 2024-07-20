{
  lib,
  writers,
  runCommand,
  python3Packages,
}:
{
  feature ? "cuda",
  name ? feature,
  libraries ? [ ], # [PythonPackage] | (PackageSet -> [PythonPackage])
}:

let
  inherit (builtins) isFunction all;
  librariesFun = if isFunction libraries then libraries else (_: libraries);
in

assert lib.assertMsg (
  isFunction libraries || all (python3Packages.hasPythonModule) libraries
) "writeGpuTestPython was passed `libraries` from the wrong python release";

content:

let
  interpreter = python3Packages.python.withPackages librariesFun;
  tester =
    runCommand "tester-${name}"
      {
        inherit content;
        passAsFile = [ "content" ];
      }
      ''
        mkdir -p "$out"/bin
        cat << EOF >"$out"/bin/"tester-${name}"
        #!${lib.getExe interpreter}
        EOF
        cat "$contentPath" >>"$out"/bin/"tester-${name}"
      '';
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
