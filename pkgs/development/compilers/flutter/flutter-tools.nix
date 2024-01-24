{ systemPlatform
, buildDartApplication
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
  sourceRoot = "source/packages/flutter_tools";
  postUnpack = ''chmod -R u+w "$NIX_BUILD_TOP/source"'';

  inherit patches;
  # The given patches are made for the entire SDK source tree.
  prePatch = ''pushd "$NIX_BUILD_TOP/source"'';
  postPatch = ''popd'';

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

  inherit pubspecLock;
}
