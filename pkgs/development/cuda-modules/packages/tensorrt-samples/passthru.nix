{
  backendStdenv,
  fetchzip,
  finalAttrs,
  lib,
  runCommand,
  stdenvNoCC,
  writeShellApplication,
}:
let
  older = lib.versionOlder finalAttrs.version;
  atLeast = lib.versionAtLeast finalAttrs.version;
in
{
  sample-data =
    let
      # Releases prior to 10.14.1 don't have any sample data available to them, so just use the 10.14.1 release's
      # sample data.
      sample-data_10_14_1 = {
        url = "https://github.com/NVIDIA/TensorRT/releases/download/v10.14/tensorrt_sample_data_20251106.zip";
        hash = "sha256-IA1pH8idtk/7FD1Tf0hKtyP7A5SW/2ugezyBRluG8yk=";
      };
    in
    fetchzip (
      if older "10.14.1" then
        sample-data_10_14_1
      else
        lib.getAttr finalAttrs.version {
          "10.14.1" = sample-data_10_14_1;
        }
    );

  # TODO(@connorbaker): A number of the tests fail with 10.2:
  # API Usage Error (Unable to load library: libnvinfer_builder_resource_win.so.10.2.0:
  # libnvinfer_builder_resource_win.so.10.2.0: cannot open shared object file: No such file or directory)
  # TODO(@connorbaker): Add tests for trtexec.
  testers =
    let
      mkTester =
        name: cmdArgs:
        writeShellApplication {
          name = finalAttrs.name + "-tester-" + name;
          runtimeInputs = [ finalAttrs.finalPackage ];
          text = ''
            ${lib.toShellVar "cmdArgs" cmdArgs}
            echo "running ''${cmdArgs[*]@Q}"
            "''${cmdArgs[@]}"
          '';
        };
    in
    lib.packagesFromDirectoryRecursive {
      callPackage =
        path: _:
        import path {
          inherit (finalAttrs.passthru) sample-data;
          inherit
            atLeast
            backendStdenv
            finalAttrs
            lib
            mkTester
            older
            ;
        };
      directory = ./testers;
    };

  # Wrap each of the derivations in testers in a runCommand.
  tests = lib.mapAttrsRecursiveCond (as: !(lib.isDerivation as)) (
    path: drv:
    runCommand (lib.replaceString "-tester-" "-test-" drv.name)
      {
        nativeBuildInputs = [ drv ];
        requiredSystemFeatures = [ "cuda" ];
      }
      ''
        set -euo pipefail
        mkdir -p "$out"
        "${lib.getExe drv}" | tee -a "$out/test.log" || {
          nixErrorLog "command failed with exit code $?"
          exit 1
        }
      ''
  ) finalAttrs.passthru.testers;
}
