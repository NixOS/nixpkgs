{
  lib,
  stdenv,
  gccStdenv,
  gcc9Stdenv,
  callPackage,
  isl_0_17,
  isl_0_20,
  libcCross,
  threadsCross,
  noSysDirs,
  lowPrio,
  wrapCC,
}@args:

let
  versions = import ./versions.nix;
  gccForMajorMinorVersion =
    majorMinorVersion:
    let
      atLeast = lib.versionAtLeast majorMinorVersion;
      attrName = "gcc${lib.replaceStrings [ "." ] [ "" ] majorMinorVersion}";
      pkg = lowPrio (
        wrapCC (
          callPackage ./default.nix (
            {
              inherit noSysDirs;
              inherit majorMinorVersion;
              reproducibleBuild = true;
              profiledCompiler = false;
              libcCross = if stdenv.targetPlatform != stdenv.buildPlatform then args.libcCross else null;
              threadsCross = if stdenv.targetPlatform != stdenv.buildPlatform then threadsCross else { };
              isl =
                if stdenv.hostPlatform.isDarwin then
                  null
                else if atLeast "9" then
                  isl_0_20
                # atLeast "7"
                else
                  isl_0_17;
            }
            // lib.optionalAttrs (!(atLeast "9")) {
              # gcc 10 is too strict to cross compile gcc <= 8
              stdenv =
                if (stdenv.targetPlatform != stdenv.buildPlatform) && stdenv.cc.isGNU then gcc9Stdenv else stdenv;
            }
          )
        )
      );
    in
    lib.nameValuePair attrName pkg;
in
lib.listToAttrs (map gccForMajorMinorVersion versions.allMajorVersions)
