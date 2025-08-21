{
  lib,
  newScope,
  stdenv,
  overrideCC,
  fetchgit,
  fetchurl,
  gitRelease ? null,
  officialRelease ? null,
  monorepoSrc ? null,
  version ? null,
  patchesFn ? lib.id,
  wrapCCWith,
  binutilsNoLibc,
  binutils,
  buildGccPackages,
  targetGccPackages,
  makeScopeWithSplicing',
  otherSplices,
  ...
}@args:

assert lib.assertMsg (lib.xor (gitRelease != null) (officialRelease != null)) (
  "must specify `gitRelease` or `officialRelease`"
  + (lib.optionalString (gitRelease != null) " — not both")
);

let
  monorepoSrc' = monorepoSrc;

  metadata = rec {
    inherit
      (import ./common-let.nix {
        inherit (args)
          lib
          gitRelease
          officialRelease
          version
          ;
      })
      releaseInfo
      ;
    inherit (releaseInfo) release_version version;
    inherit
      (import ./common-let.nix {
        inherit
          lib
          fetchgit
          fetchurl
          release_version
          gitRelease
          officialRelease
          monorepoSrc'
          version
          ;
      })
      gcc_meta
      monorepoSrc
      ;
    src = monorepoSrc;
    versionDir =
      (builtins.toString ../.)
      + "/${if (gitRelease != null) then "git" else lib.versions.major release_version}";
    getVersionFile =
      p:
      builtins.path {
        name = builtins.baseNameOf p;
        path =
          let
            patches = args.patchesFn (import ./patches.nix);

            constraints = patches."${p}" or null;
            matchConstraint =
              {
                before ? null,
                after ? null,
                path,
              }:
              let
                check = fn: value: if value == null then true else fn release_version value;
                matchBefore = check lib.versionOlder before;
                matchAfter = check lib.versionAtLeast after;
              in
              matchBefore && matchAfter;

            patchDir =
              toString
                (
                  if constraints == null then
                    { path = metadata.versionDir; }
                  else
                    (lib.findFirst matchConstraint { path = metadata.versionDir; } constraints)
                ).path;
          in
          "${patchDir}/${p}";
      };
  };
in
makeScopeWithSplicing' {
  inherit otherSplices;
  f =
    gccPackages:
    let
      callPackage = gccPackages.newScope (args // metadata);
    in
    {
      stdenv = overrideCC stdenv gccPackages.gcc;

      gcc-unwrapped = callPackage ./gcc {
        bintools = binutils;
      };

      libbacktrace = callPackage ./libbacktrace { };
      libiberty = callPackage ./libiberty { };
      libsanitizer = callPackage ./libsanitizer { };
      libquadmath = callPackage ./libquadmath { };

      gfortran-unwrapped = gccPackages.gcc-unwrapped.override {
        stdenv = overrideCC stdenv buildGccPackages.gcc;
        langFortran = true;
      };

      gfortran = wrapCCWith rec {
        cc = gccPackages.gfortran-unwrapped;
        libcxx = targetGccPackages.libstdcxx;
        bintools = binutils;
        extraPackages = [
          targetGccPackages.libgcc
        ];
        nixSupport.cc-cflags = [
          "-B${targetGccPackages.libgcc}/lib"
          "-B${targetGccPackages.libssp}/lib"
          "-B${targetGccPackages.libatomic}/lib"
          "-B${targetGccPackages.libgfortran}/lib/"
        ];
      };

      gfortranNoLibgfortran = wrapCCWith rec {
        cc = gccPackages.gfortran-unwrapped;
        libcxx = targetGccPackages.libstdcxx;
        bintools = binutils;
        extraPackages = [
          targetGccPackages.libgcc
        ];
        nixSupport.cc-cflags = [
          "-B${targetGccPackages.libgcc}/lib"
          "-B${targetGccPackages.libssp}/lib"
          "-B${targetGccPackages.libatomic}/lib"
        ];
      };

      gcc = wrapCCWith rec {
        cc = gccPackages.gcc-unwrapped;
        libcxx = targetGccPackages.libstdcxx;
        bintools = binutils;
        extraPackages = [
          targetGccPackages.libgcc
        ];
        nixSupport.cc-cflags = [
          "-B${targetGccPackages.libgcc}/lib"
          "-B${targetGccPackages.libssp}/lib"
          "-B${targetGccPackages.libatomic}/lib"
        ];
      };

      gccNoLibgcc = wrapCCWith rec {
        cc = gccPackages.gcc-unwrapped;
        libcxx = null;
        bintools = binutilsNoLibc;
        extraPackages = [ ];
        nixSupport.cc-cflags = [
          "-nostartfiles"
        ];
      };

      libgcc = callPackage ./libgcc {
        stdenv = overrideCC stdenv buildGccPackages.gccNoLibgcc;
      };

      gccWithLibc = wrapCCWith rec {
        cc = gccPackages.gcc-unwrapped;
        libcxx = null;
        bintools = binutils;
        extraPackages = [
          targetGccPackages.libgcc
        ];
        nixSupport.cc-cflags = [
          "-B${targetGccPackages.libgcc}/lib"
        ];
      };

      libssp = callPackage ./libssp {
        stdenv = overrideCC stdenv buildGccPackages.gccWithLibc;
      };

      gccWithLibssp = wrapCCWith rec {
        cc = gccPackages.gcc-unwrapped;
        libcxx = null;
        bintools = binutils;
        extraPackages = [
          targetGccPackages.libgcc
        ];
        nixSupport.cc-cflags = [
          "-B${targetGccPackages.libgcc}/lib"
          "-B${targetGccPackages.libssp}/lib"
        ];
      };

      libatomic = callPackage ./libatomic {
        stdenv = overrideCC stdenv buildGccPackages.gccWithLibssp;
      };

      gccWithLibatomic = wrapCCWith rec {
        cc = gccPackages.gcc-unwrapped;
        libcxx = null;
        bintools = binutils;
        extraPackages = [
          targetGccPackages.libgcc
        ];
        nixSupport.cc-cflags = [
          "-B${targetGccPackages.libgcc}/lib"
          "-B${targetGccPackages.libssp}/lib"
          "-B${targetGccPackages.libatomic}/lib"
        ];
      };

      libgfortran = callPackage ./libgfortran {
        stdenv = overrideCC stdenv buildGccPackages.gcc;
        gfortran = buildGccPackages.gfortranNoLibgfortran;
      };

      libstdcxx = callPackage ./libstdcxx {
        stdenv = overrideCC stdenv buildGccPackages.gccWithLibatomic;
      };
    };
}
