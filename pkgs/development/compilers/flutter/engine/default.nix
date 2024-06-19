{
  callPackage,
  dartSdkVersion,
  flutterVersion,
  version,
  hashes,
  url,
  patches,
  runtimeModes,
  isOptimized ? true,
  lib,
  stdenv,
}:
let
  mainRuntimeMode = builtins.elemAt runtimeModes 0;
  altRuntimeMode = builtins.elemAt runtimeModes 1;

  runtimeModesBuilds = lib.genAttrs runtimeModes (
    runtimeMode:
    callPackage ./package.nix {
      inherit
        dartSdkVersion
        flutterVersion
        version
        hashes
        url
        patches
        runtimeMode
        isOptimized
        ;
    }
  );
in
stdenv.mkDerivation (
  {
    pname = "flutter-engine";
    inherit url runtimeModes;
    inherit (runtimeModesBuilds.${mainRuntimeMode})
      meta
      src
      version
      dartSdkVersion
      isOptimized
      runtimeMode
      ;
    inherit altRuntimeMode;

    dontUnpack = true;
    dontBuild = true;

    installPhase =
      ''
        mkdir -p $out/out

        for dir in $(find $src/src -mindepth 1 -maxdepth 1); do
          ln -sf $dir $out/$(basename $dir)
        done

      ''
      + lib.concatMapStrings (
        runtimeMode:
        let
          runtimeModeBuild = runtimeModesBuilds.${runtimeMode};
          runtimeModeOut = "host_${runtimeMode}${
            lib.optionalString (!runtimeModeBuild.isOptimized) "_unopt"
          }";
        in
        ''
          ln -sf ${runtimeModeBuild}/out/${runtimeModeOut} $out/out/${runtimeModeOut}
        ''
      ) runtimeModes;
  }
  // runtimeModesBuilds
)
