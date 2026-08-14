{
  lib,
  stdenv,
  gcc_meta,
  release_version,
  version,
  monorepoSrc ? null,
  fetchpatch,
  langAda ? false,
  langC ? true,
  langCC ? true,
  langFortran ? false,
  langGo ? false,
  langJava ? false,
  langObjC ? stdenv.targetPlatform.isDarwin,
  langObjCpp ? stdenv.targetPlatform.isDarwin,
  langJit ? false,
  enablePlugin ? lib.systems.equals stdenv.hostPlatform stdenv.buildPlatform,
  buildPackages,
  isl,
  zlib,
  gmp,
  libmpc,
  mpfr,
  perl,
  texinfo,
  which,
  gettext,
  flex,
  bison,
  # Whether `monorepoSrc` is a VCS checkout rather than a release tarball. A
  # checkout lacks the generated sources (gengtype-lex.cc and friends) that a
  # tarball ships pre-built, so they have to be regenerated with flex and bison.
  fromVCS ? false,
  getVersionFile,
  buildGccPackages,
  libbacktrace,
  autoreconfHook269,
  bintools,
  # Build the shared runtime libraries, and so have the driver's specs emit
  # `-lgcc_s`. Derived the way the monolithic build derives it.
  enableTargetShared ? stdenv.targetPlatform.hasSharedLibraries,
}:
let
  inherit (stdenv) targetPlatform hostPlatform;
  targetPrefix = lib.optionalString (targetPlatform != hostPlatform) "${targetPlatform.config}-";
in
stdenv.mkDerivation (finalAttrs: {
  pname = "${targetPrefix}${if langFortran then "gfortran" else "gcc"}";
  inherit version;

  src = monorepoSrc;

  outputs = [
    "out"
    "man"
    "info"
  ];

  patches = [
    (fetchpatch {
      name = "for_each_path-functional-programming.patch";
      url = "https://github.com/gcc-mirror/gcc/commit/f23bac62f46fc296a4d0526ef54824d406c3756c.diff";
      hash = "sha256-J7SrypmVSbvYUzxWWvK2EwEbRsfGGLg4vNZuLEe6Xe0=";
    })
    (fetchpatch {
      name = "find_a_program-separate-from-find_a_file.patch";
      url = "https://github.com/gcc-mirror/gcc/commit/948eb02800777d0318ee2a38bf32076afee739f2.diff";
      hash = "sha256-doXak3VfdWR/BP9XiJaU7uJz7rex78N1oaW6CqYwKaQ=";
    })
    (fetchpatch {
      name = "simplify-find_a_program-and-find_a_file.patch";
      url = "https://github.com/gcc-mirror/gcc/commit/073b4656d07e40f83a1db7f4462ab2d68b1875a2.diff";
      hash = "sha256-kW6ZHyMzsn7snUBuDx4XLriaFGWZ1fixNc9UH8O5els=";
    })
    (fetchpatch {
      name = "for_each_path-fix-uninitialized-ret-PR121806.patch";
      url = "https://github.com/gcc-mirror/gcc/commit/6b008944e7bc3a342a734c4fcf1001d63fd0a6f8.diff";
      hash = "sha256-preG5DdRX+a0NIebsapAVnqiLYtPjsR4H5BkAXL/65g=";
    })
    (fetchpatch {
      name = "for_each_path-pass-machine-specific.patch";
      url = "https://github.com/gcc-mirror/gcc/commit/f62f68e7c4bde0385fbd2dba3e926586dd2f1281.diff";
      hash = "sha256-NsgGnTMQTnz1c4urr6jeoGOzQ4xeJ/p+F53osNDYDCA=";
    })
    (fetchpatch {
      name = "find_a_program-search-with-machine-prefix.patch";
      url = "https://github.com/gcc-mirror/gcc/commit/a514707ffd7d58b140686036c2dece43ecb7d33c.diff";
      hash = "sha256-54/HzM+aeWq8CTkQu8Pualqc/LgRLS0+8EY8uPUsD+s=";
    })

    # Not upstream yet; a follow-up to the series above (drop the `/raw` to
    # read them). They extend that series' `<target>-as` preference to `PATH`,
    # where we put the cross toolchain, so a cross compiler finds its tools
    # the way a native one does. See below for the problems `--with-as` and
    # `--with-ld` cause, and thus why we want to avoid them.
    (fetchpatch {
      name = "driver-factor-out-env-path-parsing.patch";
      url = "https://inbox.sourceware.org/gcc-patches/20260810065714.2215299-1-git@JohnEricson.me/raw";
      hash = "sha256-2qUUMWuyxX4mVaBPeNnHIiMl/aN7ejWM5stTSFWxD7g=";
    })
    (fetchpatch {
      name = "driver-search-PATH-ourselves.patch";
      url = "https://inbox.sourceware.org/gcc-patches/20260810065714.2215299-2-git@JohnEricson.me/raw";
      # The posted patch is against trunk, which spells this cast with the C++
      # operator.  GCC 15 still uses the CONST_CAST macro, and the line is
      # context rather than a change, so it cannot fuzz-match.  Rewrite it
      # here rather than keeping a forked copy of the whole patch.
      postFetch = ''
        substituteInPlace "$out" \
          --replace-fail 'string, const_cast<char **> (commands[i].argv),' \
                         'string, CONST_CAST (char **, commands[i].argv),'
      '';
      hash = "sha256-uD8xJxQus2qyNgNDN/63WnURNuUJFDkhaXPph7g/DIk=";
    })
    (fetchpatch {
      name = "driver-search-PATH-machine-prefix.patch";
      url = "https://inbox.sourceware.org/gcc-patches/20260810065714.2215299-3-git@JohnEricson.me/raw";
      hash = "sha256-Q5CJpJKD11kadIKselQdHgNe26GqojpyAAmlAyHnsB0=";
    })

    (getVersionFile "gcc/fix-collect2-paths.diff")

    # From the posting to gcc-patches, which covers every component that links
    # libbacktrace. Take only this component's non-generated files: the
    # generated ones are rebuilt by `autoreconfHook269` below, against a GCC
    # slightly different from the one the patch was made against.
    (fetchpatch {
      name = "system-libbacktrace.patch";
      url = "https://inbox.sourceware.org/gcc-patches/20260814013206.3818461-1-git@JohnEricson.me/raw";
      includes = [
        "config/libbacktrace.m4"
        "gcc/configure.ac"
        "gcc/Makefile.in"
      ];
      hash = "sha256-i+J4B5f+zrXERPqJxwjEm/JHZhDsV6Gmxx/n9+G0shM=";
    })
  ];

  enableParallelBuilding = true;

  # The patches above touch `gcc/configure.ac`, and this is the one component
  # whose `configure` nothing regenerates on its own -- it has no
  # `Makefile.am`, so it is not part of any `autoreconf` the other packages
  # run. Only `gcc` is named, because reconfiguring the whole monorepo is both
  # slow and unnecessary.
  #
  # Regenerating rather than carrying `configure` in the patch keeps that patch
  # to what was actually written, and lets it apply to a tree whose generated
  # files have moved on.
  autoreconfFlags = "--verbose --force gcc";

  # `aclocal` finds the macro added under `config/` through `ACLOCAL_AMFLAGS`
  # in a `Makefile.am`, which `gcc` does not have. Without this the macro is
  # simply undefined, and `autoconf` leaves its name in the script as literal
  # shell rather than failing.
  preAutoreconf = ''
    export ACLOCAL_PATH="$PWD/config''${ACLOCAL_PATH:+:$ACLOCAL_PATH}"
  '';

  hardeningDisable = [
    "format" # Some macro-indirect formatting in e.g. libcpp
  ];

  strictDeps = true;

  depsBuildBuild = [ buildPackages.stdenv.cc ];

  # The target assembler and linker have to be *runnable here*, during
  # configure. GCC probes them for capabilities, and a probe it cannot run is
  # not an error -- it silently records "no". Without the target `ld` on
  # `PATH`, every `gcc_cv_ld_*` probe fails that way, and the two that matter
  # most are `HAVE_GAS_HIDDEN` (which needs `gcc_cv_as_hidden` *and*
  # `gcc_cv_ld_hidden`) and `HAVE_LD_EH_FRAME_HDR`.
  #
  # Losing `HAVE_GAS_HIDDEN` is the nasty one: `-fvisibility=hidden` degrades
  # into a no-op that merely warns, so every symbol stays preemptible and GCC's
  # own same-translation-unit `R_X86_64_PC32` references become invalid when
  # linking a shared library.
  #
  # The *unwrapped* bintools: `as` and `ld` proper carry no target-libc
  # reference, so the decoupling this package set exists for still holds.
  #
  # Note this is `PATH` rather than `--with-as`/`--with-ld` on purpose. We want
  # configure to *ask* the real tools what they support, and we want it to bake
  # nothing else: those flags record `DEFAULT_ASSEMBLER`/`DEFAULT_LINKER` as
  # absolute store paths, and the driver then runs exactly those binaries
  # instead of the wrapped ones it is meant to defer to.
  depsBuildTarget = [ (bintools.bintools or bintools) ];

  nativeBuildInputs = [
    autoreconfHook269
    texinfo
    which
    gettext
  ]
  ++ lib.optional (perl != null) perl
  ++ lib.optionals fromVCS [
    flex
    bison
  ];

  buildInputs = [
    libbacktrace
    gmp
    libmpc
    mpfr
  ]
  ++ lib.optional (isl != null) isl
  ++ lib.optional (zlib != null) zlib;

  postUnpack = ''
    mkdir -p ./build
    buildRoot=$(readlink -e "./build")
  '';

  postPatch = ''
    configureScripts=$(find . -name configure)
    for configureScript in $configureScripts; do
      patchShebangs $configureScript
    done

    patchShebangs libbacktrace/install-debuginfo-for-buildid.sh
    patchShebangs runtest
  ''
  # This should kill all the stdinc frameworks that gcc and friends like to
  # insert into default search paths.
  + lib.optionalString hostPlatform.isDarwin ''
    substituteInPlace gcc/config/darwin-c.c \
      --replace 'if (stdinc)' 'if (0)'
  '';

  preConfigure =
    # Don't built target libraries, because we want to build separately
    ''
      substituteInPlace configure \
        --replace 'noconfigdirs=""' 'noconfigdirs="$noconfigdirs $target_libraries"'
    ''
    # HACK: if host and target config are the same, but the platforms are
    # actually different we need to convince the configure script that it
    # is in fact building a cross compiler although it doesn't believe it.
    +
      lib.optionalString (targetPlatform.config == hostPlatform.config && targetPlatform != hostPlatform)
        ''
          substituteInPlace configure --replace is_cross_compiler=no is_cross_compiler=yes
        ''
    # Cannot configure from src dir
    + ''
      cd "$buildRoot"

      mkdir -p "$buildRoot/libiberty/pic"
      cp ${buildGccPackages.libiberty}/lib/libiberty.a "$buildRoot/libiberty"
      cp ${buildGccPackages.libiberty}/lib/libiberty_pic.a "$buildRoot/libiberty/pic/libiberty.a"
      touch "$buildRoot/libiberty/stamp-noasandir"
      touch "$buildRoot/libiberty/stamp-h"
      touch "$buildRoot/libiberty/stamp-picdir"

      mkdir -p "$buildRoot/build-${stdenv.hostPlatform.config}"
      cp -r "$buildRoot/libiberty" "$buildRoot/build-${stdenv.hostPlatform.config}/libiberty"

      configureScript=../$sourceRoot/configure
    '';

  # Don't store the configure flags in the resulting executables.
  postConfigure = ''
    sed -e '/TOPLEVEL_CONFIGURE_ARGUMENTS=/d' -i Makefile
  '';

  dontDisableStatic = true;

  configurePlatforms = [
    "build"
    "host"
    "target"
  ];

  configureFlags = [
    # Force target prefix. The behavior if `--target` and `--host` are
    # specified is inconsistent: Sometimes specifying `--target` always causes
    # a prefix to be generated, sometimes it's only added if the `--host` and
    # `--target` differ. This means that sometimes there may be a prefix even
    # though nixpkgs doesn't expect one and sometimes there may be none even
    # though nixpkgs expects one (since not all information is serialized into
    # the config attribute). The easiest way out of these problems is to always
    # set the program prefix, so gcc will conform to our expectations.
    "--program-prefix=${targetPrefix}"

    "--disable-dependency-tracking"
    "--enable-fast-install"
    "--disable-serial-configure"
    "--disable-bootstrap"
    "--disable-decimal-float"
    "--disable-install-libiberty"
    "--disable-multilib"
    "--disable-nls"
    # Derived rather than forced off: the driver's specs only emit `-lgcc_s`
    # for a target that has shared libraries, so hardcoding this leaves every
    # throwing C++ program unlinkable even though `libgcc_s.so` is built and
    # findable. Same predicate the monolithic build uses.
    (lib.enableFeature enableTargetShared "shared")
    "--enable-default-pie"
    "--enable-languages=${
      lib.concatStrings (
        lib.intersperse "," (
          lib.optional langC "c"
          ++ lib.optional langCC "c++"
          ++ lib.optional langFortran "fortran"
          ++ lib.optional langJava "java"
          ++ lib.optional langAda "ada"
          ++ lib.optional langGo "go"
          ++ lib.optional langObjC "objc"
          ++ lib.optional langObjCpp "obj-c++"
          ++ lib.optional langJit "jit"
        )
      )
    }"
    (lib.withFeature (isl != null) "isl")
    "--without-headers"
    "--with-gnu-as"
    "--with-gnu-ld"
    # Deliberately no `--with-as` / `--with-ld`. Those bake
    # `DEFAULT_ASSEMBLER` and `DEFAULT_LINKER` -- absolute store paths -- into
    # the compiler, so the driver runs exactly those binaries and stops
    # deferring to the wrapped tools it is meant to use.
    #
    # Nothing has to be baked. At configure time the tools are on `PATH` via
    # `depsBuildTarget`, which is what the capability probes need; at use time
    # the driver finds them on `PATH` under their target-prefixed names, via
    # the `find_a_program` patches above.
    "--with-system-zlib"
    "--with-system-libbacktrace"
    "--without-included-gettext"
    "--enable-linker-build-id"
    # Deliberately *no* `--with-sysroot` / `--with-native-system-header-dir`
    # pointing at the target libc. Baking a libc store path into the compiler
    # makes every libc change rebuild the compiler, which is precisely the
    # coupling this split package set exists to remove. cc-wrapper already
    # supplies the target libc (`-idirafter <libc.dev>/include` and the
    # corresponding `-B`/`-L` flags), so the compiler proper does not need to
    # know about it -- exactly as in the LLVM package set, where `clang`
    # likewise carries no libc reference (`--without-headers` above).
  ]
  ++ lib.optionals enablePlugin [
    "--enable-plugin"
    "--enable-plugins"
  ]
  ++
    # Only pass when the arch supports it.
    # Exclude RISC-V because GCC likes to fail when the string is empty on RISC-V.
    lib.optionals (targetPlatform.isAarch || targetPlatform.isAvr || targetPlatform.isx86_64) [
      "--with-multilib-list="
    ];

  # `LIMITS_H_TEST` decides whether gcc's generated `syslimits.h` chains to the
  # target libc's `limits.h` (`#include_next`) or is emitted self-contained. It
  # defaults to a `[ -f $(BUILD_SYSTEM_HEADER_DIR)/limits.h ]` probe, which
  # necessarily fails here: we deliberately do not point the compiler at a
  # sysroot (see `configureFlags`), so there is no libc for it to find at build
  # time.
  #
  # Self-contained is the wrong answer regardless. Every target in this package
  # set is hosted, and cc-wrapper always supplies a libc, so the chained header
  # is what resolves correctly at *use* time. Without it, anything the libc's
  # `limits.h` defines and gcc's does not -- `PATH_MAX` being the common one --
  # goes missing from every libgcc source that needs it.
  makeFlags = [ "LIMITS_H_TEST=true" ];

  doCheck = false;

  postInstall = ''
    moveToOutput "lib/gcc/${targetPlatform.config}/${version}/plugin/include" "''${!outputDev}"
  '';

  passthru = {
    inherit
      langC
      langCC
      langObjC
      langObjCpp
      langAda
      langFortran
      langGo
      ;
    isGNU = true;
  };

  meta = gcc_meta // {
    homepage = "https://gcc.gnu.org/";
  };
})
