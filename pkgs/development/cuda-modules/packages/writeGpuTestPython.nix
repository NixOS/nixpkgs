{
  lib,
  runCommand,
  python3Packages,
  makeWrapper,
  writableTmpDirAsHomeHook,
}:
{
  feature ? "cuda",
  name ? if feature == null then "cpu" else feature,
  libraries ? [ ], # [PythonPackage] | (PackageSet -> [PythonPackage])
  gpuCheckArgs ? { },
  ...
}@args:

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
      (
        lib.removeAttrs args [
          "gpuCheckArgs"
          "libraries"
          "name"
        ]
        // {
          inherit content;
          nativeBuildInputs = args.nativeBuildInputs or [ ] ++ [ makeWrapper ];
          passAsFile = args.passAsFile or [ ] ++ [ "content" ];
        }
      )
      ''
        mkdir -p "$out"/bin
        cat << EOF >"$out/bin/$name"
        #!${lib.getExe interpreter}
        EOF
        cat "$contentPath" >>"$out/bin/$name"
        chmod +x "$out/bin/$name"

        if [[ -n "''${makeWrapperArgs+''${makeWrapperArgs[@]}}" ]] ; then
          wrapProgram "$out/bin/$name" ''${makeWrapperArgs[@]}
        fi
      '';
  tester' = tester.overrideAttrs (oldAttrs: {
    passthru.gpuCheck =
      runCommand "test-${name}"
        (
          gpuCheckArgs
          // {
            nativeBuildInputs = [
              tester'
            ]
            ++ gpuCheckArgs.nativeBuildInputs or [ ];

            requiredSystemFeatures =
              lib.optionals (feature != null) [ feature ] ++ gpuCheckArgs.requiredSystemFeatures or [ ];
          }
        )
        ''
          set -e
          ${tester.meta.mainProgram or (lib.getName tester')}
          touch $out
        '';
  });
in
tester'
