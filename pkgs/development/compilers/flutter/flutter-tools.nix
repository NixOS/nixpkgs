{ lib
, stdenv
, systemPlatform
, buildDartApplication
, runCommand
, git
, which
, dart
, version
, flutterSrc
, patches ? [ ]
, pubspecLock
}:

buildDartApplication.override { inherit dart; } rec {
  pname = "flutter-tools";
  inherit version;
  dartOutputType = "jit-snapshot";

  src = flutterSrc;
  sourceRoot = "${src.name}/packages/flutter_tools";
  postUnpack = ''chmod -R u+w "$NIX_BUILD_TOP/source"'';

  inherit patches;
  # The given patches are made for the entire SDK source tree.
  prePatch = ''pushd "$NIX_BUILD_TOP/source"'';
  postPatch = ''
    popd
  ''
  # Use arm64 instead of arm64e.
  + lib.optionalString stdenv.hostPlatform.isDarwin ''
    substituteInPlace lib/src/ios/xcodeproj.dart \
      --replace-fail arm64e arm64
  '';

  # When the JIT snapshot is being built, the application needs to run.
  # It attempts to generate configuration files, and relies on a few external
  # tools.
  nativeBuildInputs = [ git which ];
  preConfigure = ''
    export HOME=.
    export FLUTTER_ROOT="$NIX_BUILD_TOP/source"
    mkdir -p "$FLUTTER_ROOT/bin/cache"
    ln -s '${dart}' "$FLUTTER_ROOT/bin/cache/dart-sdk"
  '';

  dartEntryPoints."flutter_tools.snapshot" = "bin/flutter_tools.dart";
  dartCompileFlags = [ "--define=NIX_FLUTTER_HOST_PLATFORM=${systemPlatform}" ];

  # The Dart wrapper launchers are useless for the Flutter tool - it is designed
  # to be launched from a snapshot by the SDK.
  postInstall = ''
    pushd "$out"
    rm ${builtins.concatStringsSep " " (builtins.attrNames dartEntryPoints)}
    popd
  '';

  sdkSourceBuilders = {
    # https://github.com/dart-lang/pub/blob/e1fbda73d1ac597474b82882ee0bf6ecea5df108/lib/src/sdk/dart.dart#L80
    "dart" = name: runCommand "dart-sdk-${name}" { passthru.packageRoot = "."; } ''
      for path in '${dart}/pkg/${name}'; do
        if [ -d "$path" ]; then
          ln -s "$path" "$out"
          break
        fi
      done

      if [ ! -e "$out" ]; then
        echo 1>&2 'The Dart SDK does not contain the requested package: ${name}!'
        exit 1
      fi
    '';
  };

  inherit pubspecLock;
}
