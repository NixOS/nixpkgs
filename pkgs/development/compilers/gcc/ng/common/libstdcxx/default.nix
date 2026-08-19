{
  lib,
  stdenv,
  gcc_meta,
  release_version,
  version,
  getVersionFile,
  monorepoSrc ? null,
  fetchpatch,
  autoreconfHook269,
  runCommand,
  gettext,
  libgcc,
  libbacktrace,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "libstdcxx";
  inherit version;

  src = runCommand "libstdcxx-src-${version}" { src = monorepoSrc; } (
    ''
      runPhase unpackPhase

      mkdir -p "$out/gcc"
      cp gcc/BASE-VER "$out/gcc"
      cp gcc/DATESTAMP "$out/gcc"

      mkdir -p "$out/libgcc"
      cp libgcc/gthr*.h "$out/libgcc"
      cp libgcc/unwind-pe.h "$out/libgcc"

      cp -r libstdc++-v3 "$out"

      cp -r libiberty "$out"
      cp -r include "$out"
      cp -r contrib "$out"

      cp -r config "$out"
      cp -r multilib.am "$out"

      cp config.guess "$out"
      cp config.rpath "$out"
      cp config.sub "$out"
      cp config-ml.in "$out"
      cp ltmain.sh "$out"
      cp install-sh "$out"
      cp mkinstalldirs "$out"

    ''
    # `src/Makefile` runs this to compute `LTLDFLAGS`, reaching out of the
    # subdirectory for it as `$(top_srcdir)/../libtool-ldflags`. Missing, the
    # shell says "No such file or directory" and `LTLDFLAGS` silently comes out
    # empty, dropping our `LDFLAGS` from every library link.
    + ''
      cp libtool-ldflags "$out"

    ''
    # `MD5SUMS` exists only in release tarballs, not in a VCS checkout.
    + ''
      if [[ -f MD5SUMS ]]; then cp MD5SUMS "$out"; fi
    ''
  );

  outputs = [
    "out"
    "dev"
  ];

  patches = [
    (fetchpatch {
      name = "custom-threading-model.patch";
      url = "https://github.com/gcc-mirror/gcc/commit/e5d853bbe9b05d6a00d98ad236f01937303e40c4.diff";
      hash = "sha256-f0XAim3uzHnUx5lm/xO00IqBHu4YUEHF2WY+c0yCF6Y=";
      includes = [
        "config/*"
        "libstdc++-v3/acinclude.m4"
      ];
    })
    (getVersionFile "libstdcxx/force-regular-dirs.patch")

    # From the posting to gcc-patches, which covers every component that links
    # libbacktrace. Take only this component's non-generated files: the
    # generated ones are rebuilt by `autoreconfHook269` below, against a GCC
    # slightly different from the one the patch was made against.
    (fetchpatch {
      name = "system-libbacktrace.patch";
      url = "https://inbox.sourceware.org/gcc-patches/20260814013206.3818461-1-git@JohnEricson.me/raw";
      includes = [
        "config/libbacktrace.m4"
        "libstdc++-v3/acinclude.m4"
        "libstdc++-v3/src/Makefile.am"
        "libstdc++-v3/src/c++23/Makefile.am"
        "libstdc++-v3/src/c++23/stacktrace.cc"
        "libstdc++-v3/src/experimental/Makefile.am"
      ];
      hash = "sha256-qcs5N+KgBs2FScqGUZRYbAKkI2oDnm+G/ZN9RCAgZpw=";
    })
  ];

  postUnpack = ''
    mkdir -p ./build
    buildRoot=$(readlink -e "./build")
  '';

  preAutoreconf = ''
    sourceRoot=$(readlink -e "./libstdc++-v3")
    cd $sourceRoot
  '';

  enableParallelBuilding = true;

  buildInputs = [ libbacktrace ];

  nativeBuildInputs = [
    autoreconfHook269
    gettext
  ];

  preConfigure = ''
    cd "$buildRoot"
    configureScript=$sourceRoot/configure
    chmod +x "$configureScript"

  ''
  # Build libstdc++ with the *C* driver, not `g++`. `g++` implies `-lstdc++`,
  # which cannot be satisfied while building the very library that provides
  # it, and the link fails with `cannot find -lstdc++`.
  #
  # This is not our invention; it is what a monolithic build does, and
  # `libstdc++-v3/src/Makefile.am` says so where it defines `CXXLINK`:
  #
  #     We cannot allow g++ to be used since this would add -lstdc++ to the
  #     link line which of course is problematic at this point.  So, we get
  #     the top-level directory to configure libstdc++-v3 to use gcc as the
  #     C++ compilation driver.
  #
  # The top level does that through `RAW_CXX_FOR_TARGET`, which is `xgcc`
  # -- not `xg++` -- plus `-shared-libgcc` and `-nostdinc++`. Building
  # standalone there is no top level to arrange it, so arrange it here. The
  # C driver still compiles `.cc` as C++ by extension; what it drops is the
  # implicit `-lstdc++`. `-shared-libgcc` puts back the linkage `g++` would
  # have chosen, which the C driver does not default to, and `-nostdinc++`
  # keeps any already-installed C++ headers out of a build whose whole
  # purpose is to produce them.
  + ''
    cxxForLibstdcxx="$CC -shared-libgcc -nostdinc++"

  ''
  # Put libgcc's `gthr-default.h` where libstdc++ expects to find it.
  #
  # It is not a source file. In a monolithic build libgcc's Makefile creates
  # it by copying whichever `gthr-<model>.h` matches the target's thread
  # model, and libstdc++ -- configured inside that same build tree -- picks
  # it up. Standalone there is no such tree, so take the one `libgcc`
  # installed. The two implement a single threading model between them, and
  # copying libgcc's own answer is what makes them agree by construction
  # rather than by two independent guesses that can drift apart. `libgcc`
  # decided it from the libc; `gcc_cv_target_thread_file` below repeats the
  # same value.
  #
  # The consequence of getting this wrong is worth spelling out, because the
  # installed headers do not show it. `GLIBCXX_CHECK_GTHREADS` compiles
  # `#include "gthr.h"` and requires `__GTHREADS_CXX0X`, which
  # `gthr-posix.h` defines unconditionally. With no posix `gthr-default.h`
  # on the include path that test fails, configure concludes there are no
  # gthreads, and `_GLIBCXX_HAS_GTHREADS` is left undefined in
  # `c++config.h` -- so `<mutex>` compiles away and `std::mutex` does not
  # exist. Stating the intent with `--enable-threads=posix` does not help:
  # the probe overrides intent with an empirical answer, so the header has
  # to actually be there.
  + ''
    cp ${lib.getDev libgcc}/include/gthr-default.h "$sourceRoot/../libgcc/gthr-default.h"

    export CXX="$cxxForLibstdcxx"
    echo "libstdcxx: building with CXX=$CXX"
  '';

  configurePlatforms = [
    "build"
    "host"
  ];

  configureFlags = [
    "--disable-dependency-tracking"
    # The same answer `libgcc` used, and the model of the `gthr-default.h`
    # copied in above. A mismatch here is silent: the unwinder's locks vanish
    # while `libstdc++` still hands out `std::thread`.
    "gcc_cv_target_thread_file=${libgcc.threadModel}"
    "cross_compiling=true"
    "--disable-multilib"

    "--with-system-libbacktrace"

    # `gnu` is the glibc locale model: `config/locale/gnu/ctype_members.cc`
    # reads `__ctype_b`, which only glibc has. Forcing it everywhere breaks any
    # other libc -- on musl the build fails converting `const unsigned short *`
    # to `const ctype_base::mask *`. Configure picks the right model from the
    # host triple on its own, as it does for the monolithic build, which passes
    # no `--enable-clocale` at all.

    "--disable-libstdcxx-pch"
    "--disable-vtable-verify"
    "--enable-libstdcxx-visibility"
    "--with-default-libstdcxx-abi=new"
  ];

  hardeningDisable = [
    # PATH_MAX
    "fortify"
  ];

  postInstall = ''
    moveToOutput lib/libstdc++.modules.json "$dev"
  '';

  doCheck = true;

  passthru = {
    isGNU = true;
  };

  meta = gcc_meta // {
    homepage = "https://gcc.gnu.org/onlinedocs/libstdc++";
    description = "GNU C++ Library";
  };
})
