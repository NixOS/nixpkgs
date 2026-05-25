{
  callPackage,
  dartSdkVersion,
  flutterVersion,
  swiftshaderHash,
  swiftshaderRev,
  version,
  hashes,
  url,
  patches,
  runtimeModes,
  lib,
  stdenv,
  ...
}@args:
let
  mainRuntimeMode = args.mainRuntimeMode or builtins.elemAt runtimeModes 0;
  altRuntimeMode = args.altRuntimeMode or builtins.elemAt runtimeModes 1;

  runtimeModesBuilds = lib.genAttrs runtimeModes (
    runtimeMode:
    callPackage ./package.nix {
      inherit
        dartSdkVersion
        flutterVersion
        swiftshaderHash
        swiftshaderRev
        version
        hashes
        url
        patches
        runtimeMode
        ;
      isOptimized = args.isOptimized or runtimeMode != "debug";
    }
  );
in
stdenv.mkDerivation (
  {
    pname = "flutter-engine";
    inherit url runtimeModes altRuntimeMode;
    inherit (runtimeModesBuilds.${mainRuntimeMode}) version src meta;

    dontUnpack = true;
    dontBuild = true;

    installPhase = ''
      runHook preInstall

      mkdir --parents $out/out
    ''
    + lib.concatMapStrings (
      runtimeMode:
      let
        runtimeModeBuild = runtimeModesBuilds.${runtimeMode};
        runtimeModeOut = runtimeModeBuild.outName;
      in
      ''
        ln --symbolic --force ${runtimeModeBuild}/out/${runtimeModeOut} $out/out/${runtimeModeOut}
      ''
    ) runtimeModes
    + ''
      runHook postInstall
    '';

    passthru = {
      inherit (runtimeModesBuilds.${mainRuntimeMode})
        dartSdkVersion
        isOptimized
        runtimeMode
        outName
        dart
        swiftshader
        ;
    };
  }
  // runtimeModesBuilds
)
