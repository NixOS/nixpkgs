{ lib
, stdenv
, pkgs
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
      majorVersion = lib.versions.major majorMinorVersion;
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
        # do not allow version skew when cross-building gcc
        #
        # When `gcc` is cross-built (`build` != `target` && `host` == `target`)
        # `gcc` assumes that it has a compatible cross-compiler in the environment
        # that can build target libraries. Version of a cross-compiler has to
        # match the compiler being cross-built as libraries frequently use fresh
        # compiler features, like `-std=c++26` or target-specific types like
        # `_Bfloat16`.
        # Version mismatch causes build failures like:
        #     https://github.com/NixOS/nixpkgs/issues/351905
        #
        # Similar problems (but on a smaller scale) happen when a `gcc`
        # cross-compiler is built (`build` == `host` && `host` != `target`) built
        # by a mismatching version of a native compiler (`build` == `host` &&
        # `host` == `target`).
        #
        # Let's fix both problems by requiring the same compiler version for
        # cross-case.
        stdenv = if (stdenv.targetPlatform != stdenv.buildPlatform || stdenv.hostPlatform != stdenv.targetPlatform) && stdenv.cc.isGNU then pkgs."gcc${majorVersion}Stdenv" else stdenv;
      }));
    in
      lib.nameValuePair attrName pkg;
in
lib.listToAttrs (map gccForMajorMinorVersion versions.allMajorVersions)

