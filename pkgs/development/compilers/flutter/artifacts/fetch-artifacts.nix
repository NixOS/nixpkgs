# Schema:
# ${flutterVersion}.${targetPlatform}.${hostPlatform}
#
# aarch64-darwin as a host is not yet supported.
# https://github.com/flutter/flutter/issues/60118
{
  lib,
  runCommand,
  xorg,
  cacert,
  unzip,

  flutterPlatform,
  systemPlatform,
  flutter,
  hash,
}:

let
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

  flutter' = flutter.override {
    # Use a version of Flutter with just enough capabilities to download
    # artifacts.
    supportedTargetFlutterPlatforms = [ ];

    # Modify flutter-tool's system platform in order to get the desired platform's hashes.
    flutter = flutter.unwrapped.override {
      flutterTools = flutter.unwrapped.tools.override {
        inherit systemPlatform;
      };
    };
  };
in
runCommand "flutter-artifacts-${flutterPlatform}-${systemPlatform}"
  {
    nativeBuildInputs = [
      xorg.lndir
      flutter'
      unzip
    ];

    NIX_FLUTTER_TOOLS_VM_OPTIONS = "--root-certs-file=${cacert}/etc/ssl/certs/ca-bundle.crt";
    NIX_FLUTTER_OPERATING_SYSTEM =
      {
        "x86_64-linux" = "linux";
        "aarch64-linux" = "linux";
        "x86_64-darwin" = "macos";
        "aarch64-darwin" = "macos";
      }
      .${systemPlatform};

    outputHash = hash;
    outputHashMode = "recursive";
    outputHashAlgo = "sha256";

    passthru = {
      inherit flutterPlatform;
    };
  }
  (
    ''
      export FLUTTER_ROOT="$NIX_BUILD_TOP"
      lndir -silent '${flutter'}' "$FLUTTER_ROOT"
      rm -rf "$FLUTTER_ROOT/bin/cache"
      mkdir "$FLUTTER_ROOT/bin/cache"
    ''
    + lib.optionalString (lib.versionAtLeast flutter'.version "3.26") ''
      mkdir "$FLUTTER_ROOT/bin/cache/dart-sdk"
      lndir -silent '${flutter'}/bin/cache/dart-sdk' "$FLUTTER_ROOT/bin/cache/dart-sdk"
    ''
    + ''

      HOME="$(mktemp -d)" flutter precache ${
        lib.optionalString (
          flutter ? engine && flutter.engine.meta.available
        ) "--local-engine ${flutter.engine.outName}"
      } \
        -v '--${flutterPlatform}' ${
          builtins.concatStringsSep " " (map (p: "'--no-${p}'") (lib.remove flutterPlatform flutterPlatforms))
        }

      rm -rf "$FLUTTER_ROOT/bin/cache/lockfile"
    ''
    + lib.optionalString (lib.versionAtLeast flutter'.version "3.26") ''
      rm -rf "$FLUTTER_ROOT/bin/cache/dart-sdk"
    ''
    + ''
      find "$FLUTTER_ROOT" -type l -lname '${flutter'}/*' -delete

      cp -r bin/cache "$out"
    ''
  )
