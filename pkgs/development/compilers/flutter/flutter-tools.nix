{
  buildDartApplication,
  dart,
  flutterSource,
  lib,
  patches,
  pubspecLock,
  runCommand,
  stdenv,
  version,
  which,
  writableTmpDirAsHomeHook,
}:

let
  dartEntryPoints = {
    "flutter_tools.snapshot" = "bin/flutter_tools.dart";
  };
in
buildDartApplication.override { inherit dart; } (finalAttrs: {
  __structuredAttrs = true;
  strictDeps = true;
  pname = "flutter-tools";
  inherit
    version
    patches
    pubspecLock
    dartEntryPoints
    ;

  src = flutterSource;

  sourceRoot = "${finalAttrs.src.name}/packages/flutter_tools";

  dartOutputType = "jit-snapshot";

  dartCompileFlags = [ "--define=NIX_FLUTTER_HOST_PLATFORM=${stdenv.hostPlatform.system}" ];

  # The given patches are made for the entire SDK source tree.
  prePatch = ''
    chmod --recursive u+w "../.."
    pushd "../.."
  '';

  postPatch = ''
    echo -n "${version}" > version
    popd
  ''
  + lib.optionalString stdenv.hostPlatform.isDarwin ''
    substituteInPlace lib/src/ios/xcodeproj.dart \
      --replace-fail "arm64e" "arm64"
  '';

  # When the JIT snapshot is being built, the application needs to run.
  # It attempts to generate configuration files, and relies on a few external
  # tools.
  nativeBuildInputs = [
    which
    writableTmpDirAsHomeHook
  ];

  preConfigure = ''
    export FLUTTER_ROOT=$(realpath ../../)
    mkdir --parents "$FLUTTER_ROOT/bin/cache"
    ln --symbolic "${dart}" "$FLUTTER_ROOT/bin/cache/dart-sdk"
  '';

  # The Dart wrapper launchers are useless for the Flutter tool - it is designed
  # to be launched from a snapshot by the SDK.
  postInstall = ''
    rm "$out"/${builtins.concatStringsSep " " (builtins.attrNames dartEntryPoints)}
  '';

  sdkSourceBuilders = {
    # https://github.com/dart-lang/pub/blob/e1fbda73d1ac597474b82882ee0bf6ecea5df108/lib/src/sdk/dart.dart#L80
    "dart" =
      name:
      runCommand "dart-sdk-${name}" { passthru.packageRoot = "."; } ''
        for path in '${dart}/pkg/${name}'; do
          if [ -d "$path" ]; then
            ln --symbolic "$path" "$out"
            break
          fi
        done

        if [ ! -e "$out" ]; then
          echo 1>&2 'The Dart SDK does not contain the requested package: ${name}!'
          exit 1
        fi
      '';
  };
})
