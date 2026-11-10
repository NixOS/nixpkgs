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
let
  # A full libstdc++ needs a libc to link against. Without one, build the
  # freestanding subset instead: the libsupc++ headers, which are what a libc
  # that is itself partly C++ needs in order to compile. No library comes out
  # of that stage and none is wanted -- it exists only so the C++ parts of a
  # libc have `<new>` and friends to include.
  hosted = stdenv.cc.libc != null && !(stdenv.cc.libc.headersOnly or false);

  cxxForLibstdcxxFlags = [
    "-shared-libgcc"
    "-nostdinc++"
  ]
  # libstdc++ ships headers named after C headers (`stdlib.h`, `math.h`, ...)
  # which shadow the C library's in C++. They forward by re-exporting from
  # `<cstdlib>` and friends, and most of what they re-export -- `malloc` and
  # `free` among it -- sits behind `#if _GLIBCXX_HOSTED`. So in a freestanding
  # build any header that reaches for plain `<stdlib.h>` gets one with no
  # `malloc` in it. gcc's own `mm_malloc.h` does exactly that, and on this
  # target it is unavoidable: `unwind.h` pulls in `<windows.h>` for SEH, which
  # reaches the x86 intrinsics headers.
  #
  # This macro is libstdc++'s own way of saying "forward to the real C header",
  # which is what its sources want while it is being built.
  # The C driver flags libstdc++ is built with. `-shared-libgcc` puts back the
  # linkage `g++` would have chosen and `-nostdinc++` keeps any installed C++
  # headers out; see the `RAW_CXX_FOR_TARGET` note at `preConfigure`.
  ++ lib.optionals (!hosted) [ "-D_GLIBCXX_INCLUDE_NEXT_C_HEADERS" ];
in
stdenv.mkDerivation (finalAttrs: {
  pname = "libstdcxx" + lib.optionalString (!hosted) "-no-libc";
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

    ''
    # Target-specific `gthr` headers live under `libgcc/config/<cpu>/` rather
    # than at the top of `libgcc`, and libstdc++'s `gthr-default.h` rule names
    # them by path relative to the tree root, so reproduce that layout.
    + ''
      cp --parents libgcc/config/*/gthr*.h "$out"

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

  patches =
    # A backport of a commit that is in the GCC 16 release branch already.
    lib.optionals (lib.versionOlder release_version "16") [
      (fetchpatch {
        name = "custom-threading-model.patch";
        url = "https://github.com/gcc-mirror/gcc/commit/e5d853bbe9b05d6a00d98ad236f01937303e40c4.diff";
        hash = "sha256-f0XAim3uzHnUx5lm/xO00IqBHu4YUEHF2WY+c0yCF6Y=";
        includes = [
          "config/*"
          "libstdc++-v3/acinclude.m4"
        ];
      })
    ]
    ++ [
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

  # We don't need `std::backtrace` in the bootstrap pre-libc libstdc++
  buildInputs = lib.optional hosted libbacktrace;

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
    cxxForLibstdcxx="$CC ${lib.escapeShellArgs cxxForLibstdcxxFlags}"

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
  ''
  # `--enable-static` is not enough on its own here, which is why this is
  # done to the output rather than the input. configure agrees with us --
  # `config.log` records `enable_static=yes` -- but libtool's Windows
  # handling reassigns that variable while working out what a DLL-based
  # target can build, and `build_old_libs` is substituted from the value it
  # lands on. With shared libraries off as well, the generated script ends
  # up refusing both kinds and `make` stops at "not configured to build any
  # kind of library". Put the one answer back that this build needs.
  + lib.optionalString (!hosted) ''
    enableStaticInLibtool() {
      local lt
      for lt in $(find "$buildRoot" -type f -name libtool); do
        sed -i 's/^build_old_libs=no$/build_old_libs=yes/' "$lt"
      done
    }
    postConfigureHooks+=(enableStaticInLibtool)
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

    (lib.enableFeature hosted "libstdcxx-backtrace")
    # This is safely ignored when we disable the above
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
  ]
  ++ lib.optionals (!hosted) [
    "--disable-hosted-libstdcxx"

    # We can only statically link when we don't yet have a libc. Might
    # have been able to autodetect but better to be explicit.
    "--enable-static"
    "--disable-shared"

    # Answer the C library's capabilities from a table instead of
    # probing for them: every probe is a link test, and there is nothing
    # here to link against. It selects an `os_include_dir` and hardcodes
    # a batch of `HAVE_*`.
    #
    # `build` != `host` already sets `GLIBCXX_IS_NATIVE=false` which is
    # supposed to be sufficient for this, at least if I am reading
    # https://github.com/gcc-mirror/gcc/blob/4db0e8df15bef836558857c291c323add11d035c/libstdc%2B%2B-v3/configure.ac#L310-L342
    # correctly.
    #
    # However, it isn't in fact sufficient, and we will get
    # post-GCC_NO_EXECUTABLES would-link configure errors. This newlib
    # flag actually does do the job. While nothing here uses newlib, the
    # table is close enough -- none of it reaches the libsupc++ headers,
    # which are all this stage installs.
    "--with-newlib"

    # Disabling backgtrace (as we do above) does not stop its `fcntl`
    # and `getexecname` probes, which run before anything consults the
    # flag, and which link, causing more post-GCC_NO_EXECUTABLES
    # would-link configure errors.
    #
    # `--with-target-subdir` stops those probes, for a reason its name
    # does not suggest. Upstream tests it only for emptiness -- never as
    # a path -- and uses it to mean "I am an in-tree GCC target
    # library", which it takes as "I cannot link", answering from a
    # `case "${host}"` table instead of probing. It says so at the
    # `dl_iterate_phdr` check just above: "When built as a GCC target
    # library, we can't do a link test." So `.` here is not a directory
    # we use; it is that claim.
    #
    # The table's answers happen to be the true ones for this host:
    # `fcntl` yes (only mingw is excluded) and `getexecname` no (only
    # solaris2).
    "--with-target-subdir=."
  ];

  hardeningDisable = [
    # PATH_MAX
    "fortify"
  ];

  # Not just tidiness: the manifest names paths under the header directory, so
  # leaving it in `lib` makes `out` refer to `dev` and the outputs cycle.
  postInstall = ''
    moveToOutput lib/libstdc++.modules.json "$dev"
  '';

  # Nothing to run the testsuite against before there is a libc.
  doCheck = hosted;

  passthru = {
    isGNU = true;
  };

  meta = gcc_meta // {
    homepage = "https://gcc.gnu.org/onlinedocs/libstdc++";
    description = "GNU C++ Library";
    # The freestanding, pre-libc build exists for exactly one reason:
    # Cygwin's libc is partly C++ and so needs C++ headers before it
    # exists itself. Elsewhere it is unneeded, and we don't care whether
    # it builds or not at this time. (And it appears to not build at
    # this time). Marking broken rather because in principle it ought to
    # work.
    broken = !hosted && !stdenv.hostPlatform.isCygwin;
  };
})
