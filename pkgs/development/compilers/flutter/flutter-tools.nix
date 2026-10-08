{
  lib,
  stdenv,
  systemPlatform,
  buildDartApplication,
  runCommand,
  writeTextFile,
  git,
  which,
  dart,
  version,
  flutterSrc,
  patches ? [ ],
  pubspecLock,
  engineVersion,
}:

let
  # https://github.com/flutter/flutter/blob/17c92b7ba68ea609f4eb3405211d019c9dbc4d27/engine/src/flutter/tools/engine_tool/test/commands/stamp_command_test.dart#L125
  engine_stamp = writeTextFile {
    name = "engine_stamp";
    text = builtins.toJSON {
      build_date = "2025-06-27T12:30:00.000Z";
      build_time_ms = 1751027400000;
      git_revision = engineVersion;
      git_revision_date = "2025-06-27T17:11:53-07:00";
      content_hash = "1111111111111111111111111111111111111111";
    };
  };

  dartEntryPoints."flutter_tools.snapshot" = "bin/flutter_tools.dart";
in
buildDartApplication.override { inherit dart; } {
  pname = "flutter-tools";
  inherit version dartEntryPoints;
  dartOutputType = "jit-snapshot";

  src = flutterSrc;
  sourceRoot = "${flutterSrc.name}/packages/flutter_tools";

  inherit patches;
  # The given patches are made for the entire SDK source tree.
  prePatch = ''
    chmod --recursive u+w "../.."
    pushd "../.."
  '';
  postPatch = ''
    popd
  ''
  # Use arm64 instead of arm64e.
  + lib.optionalString stdenv.hostPlatform.isDarwin ''
    substituteInPlace lib/src/ios/xcodeproj.dart \
      --replace-fail arm64e arm64
  ''
  # need network
  + lib.optionalString (lib.versionAtLeast version "3.35.0") ''
    cp ${engine_stamp} ../../bin/cache/engine_stamp.json
    substituteInPlace lib/src/flutter_cache.dart \
      --replace-fail "registerArtifact(FlutterEngineStamp(this, logger));" ""
  '';

  # When the JIT snapshot is being built, the application needs to run.
  # It attempts to generate configuration files, and relies on a few external
  # tools.
  nativeBuildInputs = [
    git
    which
  ];
  preConfigure = ''
    export HOME=.
    export FLUTTER_ROOT="$(realpath ../../)"
    mkdir --parents "$FLUTTER_ROOT/bin/cache"
    ln --symbolic '${dart}' "$FLUTTER_ROOT/bin/cache/dart-sdk"
  '';

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
    "dart" =
      name:
      runCommand "dart-sdk-${name}" { passthru.packageRoot = "."; } ''
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
