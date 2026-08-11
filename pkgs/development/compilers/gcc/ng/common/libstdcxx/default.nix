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

  nativeBuildInputs = [
    autoreconfHook269
    gettext
  ];

  preConfigure = ''
    cd "$buildRoot"
    configureScript=$sourceRoot/configure
    chmod +x "$configureScript"

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

    "--enable-clocale=gnu"
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
