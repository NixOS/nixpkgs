{ lib, callPackage }:

let
  oss = [
    {
      name = "linux";
      isLinux = true;
      isWindows = false;
      isDarwin = false;
    }
    {
      name = "windows";
      isLinux = false;
      isWindows = true;
      isDarwin = false;
    }
    {
      name = "darwin";
      isLinux = false;
      isWindows = false;
      isDarwin = true;
    }
  ];

  archs = [
    {
      name = "x86_64";
      isx86_64 = true;
      isAarch64 = false;
      isRiscV64 = false;
    }
    {
      name = "aarch64";
      isx86_64 = false;
      isAarch64 = true;
      isRiscV64 = false;
    }
  ];

  hostPlatforms = (
    map
      (p: {
        inherit (p.os) isLinux isWindows isDarwin;
        inherit (p.cpu) isx86_64 isAarch64 isRiscV64;

        parsed = {
          kernel = {
            name = p.os.name;
          };
          cpu = {
            name = p.cpu.name;
          };
        };
      })
      (
        lib.cartesianProduct {
          os = oss;
          cpu = archs;
        }
      )
  );
in
(lib.unique (
  lib.concatMap (
    hostPlatform:
    callPackage ./host-artifacts.nix {
      inherit hostPlatform;
      supportedTargetFlutterPlatforms = [
        "universal"
        "web"
        "android"
        "linux"
        "macos"
        "ios"
        "windows"
      ];
    }
  ) hostPlatforms
))
