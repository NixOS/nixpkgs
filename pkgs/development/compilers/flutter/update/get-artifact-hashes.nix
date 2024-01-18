{ callPackage
, flutterPackages
, lib
, symlinkJoin
,
}:
let
  nixpkgsRoot = "@nixpkgs_root@";
  flutterCompactVersion = "@flutter_compact_version@";

  flutterPlatforms = [
    "android"
    "ios"
    "web"
    "linux"
    "windows"
    "macos"
    "fuchsia"
    "universal"
  ];
  systemPlatforms = [
    "x86_64-linux"
    "aarch64-linux"
    "x86_64-darwin"
  ];

  derivations =
    lib.foldl'
      (
        acc: flutterPlatform:
          acc
          ++ (map
            (systemPlatform:
              callPackage "${nixpkgsRoot}/pkgs/development/compilers/flutter/artifacts/fetch-artifacts.nix" {
                flutter = flutterPackages."v${flutterCompactVersion}";
                inherit flutterPlatform;
                inherit systemPlatform;
                hash = "";
              })
            systemPlatforms)
      ) [ ]
      flutterPlatforms;
in
symlinkJoin {
  name = "evaluate-derivations";
  paths = derivations;
}

