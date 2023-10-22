{ buildDartApplication
, dart
, version
, flutterSrc
, patches ? [ ]
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
  postUnpack = ''chmod -R u+w "$NIX_BUILD_TOP/source"'';

  inherit patches;
  # The given patches are made for the entire SDK source tree.
  prePatch = ''pushd "$NIX_BUILD_TOP/source"'';
  postPatch = ''popd'';

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
