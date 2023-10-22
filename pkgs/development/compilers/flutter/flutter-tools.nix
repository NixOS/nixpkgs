{ buildDartApplication
, dart
, version
, flutterSrc
, pubspecLockFile
, vendorHash
, depsListFile
}:

buildDartApplication.override { inherit dart; } rec {
  pname = "flutter-tools";
  inherit version;
  dartOutputType = "kernel";

  src = flutterSrc;
  sourceRoot = "source/packages/flutter_tools";

  dartEntryPoints."flutter_tools.snapshot" = "bin/flutter_tools.dart";

  # The Dart wrapper launchers are useless for the Flutter tool - it is designed
  # to be launched from a snapshot by the SDK.
  postInstall = ''
    pushd "$out"
    rm ${builtins.concatStringsSep " " (builtins.attrNames dartEntryPoints)}
    popd
  '';

  inherit pubspecLockFile vendorHash depsListFile;
}
