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
      (toString ../.) + "/${if (gitRelease != null) then "git" else lib.versions.major release_version}";
    getVersionFile =
      p:
      builtins.path {
        name = baseNameOf p;
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

      libiberty = callPackage ./libiberty { };
      libsanitizer = callPackage ./libsanitizer { };
      libquadmath = callPackage ./libquadmath { };

      gfortran-unwrapped = gccPackages.gcc-unwrapped.override {
        stdenv = overrideCC stdenv buildGccPackages.gcc;
        langFortran = true;
      };

      gfortran = wrapCCWith {
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
          "-B${targetGccPackages.libgomp}/lib"
          "-B${targetGccPackages.libstdcxx}/lib"
          "-B${targetGccPackages.libgfortran}/lib/"
        ];
      };

      gfortranNoLibgfortran = wrapCCWith {
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
          "-B${targetGccPackages.libgomp}/lib"
          "-I${targetGccPackages.libgomp}/lib/gcc/${metadata.release_version}/include"
        ];
      };

      gcc = wrapCCWith {
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
          "-B${targetGccPackages.libgomp}/lib"
          # `libcxx` above tells cc-wrapper where the C++ *headers* are; it does
          # not put the library itself on the link path for a GNU compiler. So
          # every C++ link failed with `cannot find -lstdc++` until this was
          # added, in the same style as the other runtime libraries.
          "-B${targetGccPackages.libstdcxx}/lib"
          "-I${targetGccPackages.libgomp}/lib/gcc/${metadata.release_version}/include"
        ];
      };

      # Stage 1 of the bootstrap chain; see ../README.md.
      #
      # No `libc` is passed: `wrapCCWith` defaults it to `bintools.libc`, and
      # `binutilsNoLibc` carries `preLibcHeaders`. That is the only place the
      # pre-libc stage is written down.
      gccNoLibgcc = wrapCCWith {
        cc = gccPackages.gcc-unwrapped;
        libcxx = null;
        bintools = binutilsNoLibc;
        extraPackages = [ ];
        nixSupport.cc-cflags = [
          "-nostartfiles"
        ];
      };

      # Built before there is a libc, and not intended for use beyond getting
      # one built. Note the two differ only by `stdenv`: which stage this is
      # follows from the compiler, never from an argument.
      libgcc-no-libc = callPackage ./libgcc {
        stdenv = overrideCC stdenv buildGccPackages.gccNoLibgcc;
      };

      # The real one, built against the finished libc, so it can use that
      # libc's threads. This is what everything above the libc gets.
      libgcc-libc = callPackage ./libgcc {
        stdenv = overrideCC stdenv buildGccPackages.gccWithLibcAndBasicLibgcc;
      };

      libgcc =
        if stdenv.hostPlatform.libc == null then gccPackages.libgcc-no-libc else gccPackages.libgcc-libc;

      # Stage 2: libgcc available, libc not yet — what compiling a libc needs.
      # `binutilsNoLibc` is what keeps the libc out, so nothing here refers to
      # a libc derivation and the cycle stays broken.
      gccWithLibgcc = wrapCCWith {
        cc = gccPackages.gcc-unwrapped;
        libcxx = null;
        bintools = binutilsNoLibc;
        extraPackages = [
          targetGccPackages.libgcc-no-libc
        ];
        nixSupport.cc-cflags = [
          "-B${targetGccPackages.libgcc-no-libc}/lib"
        ];
      };

      # Stage 3: real libc, bootstrap libgcc still. The finished libgcc is what
      # this is about to build.
      gccWithLibcAndBasicLibgcc = wrapCCWith {
        cc = gccPackages.gcc-unwrapped;
        libcxx = null;
        bintools = binutils;
        extraPackages = [
          targetGccPackages.libgcc-no-libc
        ];
        nixSupport.cc-cflags = [
          "-B${targetGccPackages.libgcc-no-libc}/lib"
        ];
      };

      gccWithLibc = wrapCCWith {
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

      gccWithLibssp = wrapCCWith {
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

      gccWithLibatomic = wrapCCWith {
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

      libgomp = callPackage ./libgomp {
        stdenv = overrideCC stdenv buildGccPackages.gccWithLibatomic;
      };
    };
}
