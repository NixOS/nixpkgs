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
  windows,
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

  # libgomp is OpenMP on top of pthreads, and will refuse to build with
  # any other threading model.
  hasLibgomp = targetGccPackages.libgcc.threadModel == "posix";

  libgompCflags = lib.optionals hasLibgomp [
    "-B${targetGccPackages.libgomp}/lib"
  ];
  libgompIncludeCflags = lib.optionals hasLibgomp [
    "-I${targetGccPackages.libgomp}/lib/gcc/${metadata.release_version}/include"
  ];

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

      # Every compiler from the threaded `libgcc-libc` onwards needs the
      # threading library's headers and import library: that is what
      # `gthr-default.h` includes and what libstdc++ and user code link
      # against. As with the runtime libraries, it is the *target* build.
      threadsPackages = lib.optional (targetGccPackages.threads != null) targetGccPackages.threads;

      # `extraPackages` only reaches builds that go through a stdenv, so name
      # the directories here too, as the runtime libraries are: otherwise the
      # wrapped compiler run by hand cannot find the `mcfgthread` header.
      threadsCflags = lib.optionals (targetGccPackages.threads != null) [
        "-B${targetGccPackages.threads}/lib"
        "-isystem ${lib.getDev targetGccPackages.threads}/include"
      ];

      # A gcc *configured* for a threading model links that model's library
      # through its own specs. Ours is configured independently of the runtimes
      # (see ../README.md), so the flag has to come from the wrapper instead;
      # without it libstdc++ fails to link on undefined `__MCF_gthr_*`.
      #
      # A whole `nixSupport` fragment rather than just the flag list: an empty
      # `cc-ldflags` still gets written by `cc-wrapper`, so setting the
      # attribute unconditionally would rebuild every wrapper everywhere.
      threadsNixSupport = lib.optionalAttrs ((targetGccPackages.threads.threadModel or null) == "mcf") {
        cc-ldflags = [ "-lmcfgthread" ];
      };
    in
    {
      # Where the libc's own threading is not the one we want, a separate
      # library supplies it: MinGW offers only `win32`, and `mcfgthreads` gives
      # `mcf`, which is the better answer on Windows. `null`, the answer
      # everywhere else, means "whatever the libc offers".
      # The model is not written down here; the package declares it, in the
      # same `passthru.threadModel` a libc uses.
      #
      # This stays out of the bootstrap cycle by itself: it is built with
      # `windows.crossThreadsStdenv`, which on `useGccNG` platforms is stage 3
      # — real libc, bootstrap single-threaded libgcc — the very compiler that
      # goes on to build the threaded `libgcc-libc`.
      threads = if stdenv.hostPlatform.isMinGW then windows.mcfgthreads else null;

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
        ]
        ++ threadsPackages;
        nixSupport = threadsNixSupport // {
          cc-cflags = [
            "-B${targetGccPackages.libgcc}/lib"
            "-B${targetGccPackages.libssp}/lib"
            "-B${targetGccPackages.libatomic}/lib"
          ]
          ++ libgompCflags
          ++ [
            "-B${targetGccPackages.libstdcxx}/lib"
            "-B${targetGccPackages.libgfortran}/lib/"
            # `libgfortran.spec`, which the driver reads from the directory
            # above, links `-lquadmath` unconditionally.
            "-B${targetGccPackages.libquadmath}/lib"
          ]
          ++ threadsCflags;
        };
      };

      gfortranNoLibgfortran = wrapCCWith {
        cc = gccPackages.gfortran-unwrapped;
        libcxx = targetGccPackages.libstdcxx;
        bintools = binutils;
        extraPackages = [
          targetGccPackages.libgcc
        ]
        ++ threadsPackages;
        nixSupport = threadsNixSupport // {
          cc-cflags = [
            "-B${targetGccPackages.libgcc}/lib"
            "-B${targetGccPackages.libssp}/lib"
            "-B${targetGccPackages.libatomic}/lib"
          ]
          ++ libgompCflags
          ++ libgompIncludeCflags
          ++ threadsCflags;
        };
      };

      gcc = wrapCCWith {
        cc = gccPackages.gcc-unwrapped;
        libcxx = targetGccPackages.libstdcxx;
        bintools = binutils;
        extraPackages = [
          targetGccPackages.libgcc
        ]
        ++ threadsPackages;
        nixSupport = threadsNixSupport // {
          cc-cflags = [
            "-B${targetGccPackages.libgcc}/lib"
            "-B${targetGccPackages.libssp}/lib"
            "-B${targetGccPackages.libatomic}/lib"
          ]
          ++ libgompCflags
          ++ [
            # `libcxx` above tells cc-wrapper where the C++ *headers* are; it does
            # not put the library itself on the link path for a GNU compiler. So
            # every C++ link failed with `cannot find -lstdc++` until this was
            # added, in the same style as the other runtime libraries.
            "-B${targetGccPackages.libstdcxx}/lib"
          ]
          ++ libgompIncludeCflags
          ++ threadsCflags;
        };
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
        # The bootstrap libgcc predates the threading library. Spelled out so
        # `callPackage` does not fill it in from the set's own `threads`.
        threads = null;
      };

      # The real one, built against the finished libc, so it can use that
      # libc's threads — or the separate threading library where we have asked
      # for one. This is what everything above the libc gets.
      libgcc-libc = callPackage ./libgcc {
        stdenv = overrideCC stdenv buildGccPackages.gccWithLibcAndBasicLibgcc;
        # Spelled out for the same reason as the `null` above, and so that it
        # is this set's own answer.
        inherit (gccPackages) threads;
      };

      libgcc =
        if stdenv.hostPlatform.libc == null then gccPackages.libgcc-no-libc else gccPackages.libgcc-libc;

      # Stage 2: libgcc available, libc not yet — what compiling a libc needs.
      # `binutilsNoLibc` is what keeps the libc out, so nothing here refers to
      # a libc derivation and the cycle stays broken.
      gccWithLibgccNoCxx = wrapCCWith {
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

      # Freestanding libstdc++ not depending on any libc
      libstdcxx-no-libc = callPackage ./libstdcxx {
        stdenv = overrideCC stdenv buildGccPackages.gccWithLibgccNoCxx;
        # The set's plain `libgcc` is the finished one, which is built after
        # the libc; only the bootstrap libgcc exists this early.
        libgcc = gccPackages.libgcc-no-libc;
      };

      gccWithLibgcc =
        # Cygwin's libc is in partly C++ and needs C++ headers to build.
        if stdenv.targetPlatform.isCygwin then
          wrapCCWith {
            cc = gccPackages.gcc-unwrapped;
            libcxx = targetGccPackages.libstdcxx-no-libc;
            bintools = binutilsNoLibc;
            extraPackages = [
              targetGccPackages.libgcc-no-libc
            ];
            nixSupport.cc-cflags = [
              "-B${targetGccPackages.libgcc-no-libc}/lib"
              # See above for why `libcxx = ...` is not enough.
              "-B${targetGccPackages.libstdcxx-no-libc}/lib"
            ];
          }
        else
          gccPackages.gccWithLibgccNoCxx;

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
        ]
        ++ threadsPackages;
        nixSupport = threadsNixSupport // {
          cc-cflags = [
            "-B${targetGccPackages.libgcc}/lib"
          ]
          ++ threadsCflags;
        };
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
        ]
        ++ threadsPackages;
        nixSupport = threadsNixSupport // {
          cc-cflags = [
            "-B${targetGccPackages.libgcc}/lib"
            "-B${targetGccPackages.libssp}/lib"
          ]
          ++ threadsCflags;
        };
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
        ]
        ++ threadsPackages;
        nixSupport = threadsNixSupport // {
          cc-cflags = [
            "-B${targetGccPackages.libgcc}/lib"
            "-B${targetGccPackages.libssp}/lib"
            "-B${targetGccPackages.libatomic}/lib"
          ]
          ++ threadsCflags;
        };
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
