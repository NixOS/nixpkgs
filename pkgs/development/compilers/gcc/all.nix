{ lib
, stdenv
, gccStdenv
, gcc9Stdenv
, callPackage
, isl_0_20
, libcCross
, threadsCross
, noSysDirs
, lowPrio
, wrapCC
}@args:

let
  versions = import ./versions.nix;
  gccForMajorMinorVersion = majorMinorVersion:
    let
      atLeast = lib.versionAtLeast majorMinorVersion;
      attrName = "gcc${lib.replaceStrings ["."] [""] majorMinorVersion}";
      pkg = lowPrio (wrapCC (callPackage ./default.nix {
        inherit noSysDirs;
        inherit majorMinorVersion;
        reproducibleBuild = true;
        profiledCompiler = false;
        libcCross = if stdenv.targetPlatform != stdenv.buildPlatform then args.libcCross else null;
        threadsCross = if stdenv.targetPlatform != stdenv.buildPlatform then threadsCross else { };
        isl = if stdenv.hostPlatform.isDarwin then null else isl_0_20;
      }));
    in
      lib.nameValuePair attrName pkg;
in
lib.listToAttrs (map gccForMajorMinorVersion versions.allMajorVersions)

