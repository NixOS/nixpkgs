{ lib
, runCommand
, cacert
, unzip

, platform
, flutter
, hash
}:

let
  platforms = [
    "android"
    "ios"
    "web"
    "linux"
    "windows"
    "macos"
    "fuchsia"
    "universal"
  ];
in
runCommand "flutter-artifacts-${platform}"
{
  nativeBuildInputs = [
    (flutter.override {
      # Use a version of Flutter with just enough capabilities to download
      # artifacts.
      supportedTargetPlatforms = [ ];
    })
    unzip
  ];

  NIX_FLUTTER_TOOLS_VM_OPTIONS = "--root-certs-file=${cacert}/etc/ssl/certs/ca-bundle.crt";

  outputHash = hash;
  outputHashMode = "recursive";
  outputHashAlgo = "sha256";

  passthru = {
    inherit platform;
  };
} ''
  runHook preBuild

  mkdir -p "$out"
  HOME="$NIX_BUILD_TOP" FLUTTER_CACHE_DIR="$out" flutter precache -v '--${platform}' ${builtins.concatStringsSep " " (map (p: "'--no-${p}'") (lib.remove platform platforms))}

  runHook postBuild
''
