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

  # TODO(@connorbaker): Add tests for trtexec.
  testers =
    let
      mkTesters = lib.flip import {
        inherit (finalAttrs.passthru) mkTester sample-data;
        inherit
          atLeast
          backendStdenv
          finalAttrs
          lib
          older
          ;
      };
    in
    # Filter out sets of testers which are completely empty (not available on this architecture, this version, etc.).
    lib.filterAttrs (_: attrs: attrs != { }) (
      # Construct all the testers from the filesystem.
      lib.packagesFromDirectoryRecursive {
        callPackage = path: _: mkTesters path;
        directory = ./testers;
      }
    );

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
