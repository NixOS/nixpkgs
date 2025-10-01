{
  lib,
  stdenv,
  pkgsBuildBuild,
  fetchpatch,
  libunistring,
  libffi,
  boehmgc,
  gmp,
  readline,
  libtool,
  buildGuile,
}:

buildGuile (finalAttrs: {
  version = "2.0.13";
  srcHash = "sha256-7oBzxFgrtPBkEkUv313RharmB0QfExPIJPRL3WaLC94=";

  patches = [
    # Small fixes to Clang compiler
    ./clang.patch
    # Self-explanatory
    ./disable-gc-sensitive-tests.patch
    # Read the header of the patch to more info
    ./eai_system.patch
    # RISC-V endianness
    ./riscv.patch
    # Fixes stability issues with 00-repl-server.test
    (fetchpatch {
      url = "https://git.savannah.gnu.org/cgit/guile.git/patch/?id=2fbde7f02adb8c6585e9baf6e293ee49cd23d4c4";
      hash = "sha256-+xwK/3BYdqV7tmS1/eYgBdPxZjG19PMHwNHGwCsNzFw=";
    })
    ./filter-mkostemp-darwin.patch
    (fetchpatch {
      url = "https://gitlab.gnome.org/GNOME/gtk-osx/raw/52898977f165777ad9ef169f7d4818f2d4c9b731/patches/guile-clocktime.patch";
      hash = "sha256-BwgdtWvRgJEAnzqK2fCQgRHU0va50VR6SQfJpGzjm4s=";
    })
  ]
  ++ (lib.optional (coverageAnalysis != null) ./gcov-file-name.patch);

  depsBuildBuild = lib.optional (
    stdenv.hostPlatform != stdenv.buildPlatform
  ) pkgsBuildBuild.guile_2_0;

  buildInputs = [
    libunistring
    libffi
  ];

  propagatedBuildInputs = [
    boehmgc

    # These ones aren't normally needed here, but `libguile*.la' has '-l'
    # flags for them without corresponding '-L' flags. Adding them here will
    # add the needed `-L' flags.  As for why the `.la' file lacks the `-L'
    # flags, see below.
    libunistring
  ];

  enableParallelBuilding = false;

  # Explicitly link against libgcc_s, to work around the infamous
  # "libgcc_s.so.1 must be installed for pthread_cancel to work".

  # don't have "libgcc_s.so.1" on darwin
  env = {
    LDFLAGS = lib.optionalString (
      !stdenv.hostPlatform.isDarwin && !stdenv.hostPlatform.isMusl
    ) "-lgcc_s";
  }
  // (lib.optionalAttrs (!stdenv.hostPlatform.isLinux) {
    # Work around <https://bugs.gnu.org/14201>.
    SHELL = stdenv.shell;
    CONFIG_SHELL = stdenv.shell;
  });

  configureFlags = lib.optionals stdenv.hostPlatform.isSunOS [
    # Make sure the right <gmp.h> is found, and not the incompatible
    # /usr/include/mp.h from OpenSolaris. See
    # <https://lists.gnu.org/archive/html/hydra-users/2012-08/msg00000.html>
    # for details.
    "--with-libgmp-prefix=${lib.getDev gmp}"

    # Same for these (?).
    "--with-libreadline-prefix=${lib.getDev readline}"
    "--with-libunistring-prefix=${libunistring}"

    # See below.
    "--without-threads"
  ];

  postInstall = ''
    substituteInPlace "$out/lib/pkgconfig/guile"-*.pc \
      --replace-fail "-lunistring" "-L${libunistring}/lib -lunistring" \
      --replace-fail "-lltdl" "-L${libtool.lib}/lib -lltdl" \
      --replace-fail "includedir=$out" "includedir=$dev"

    sed -i "$out/lib/pkgconfig/guile"-*.pc    \
        -e "s|^Cflags:\(.*\)$|Cflags: -I${libunistring.dev}/include \1|g ;"
  '';

  setupHook = ./setup-hook-2.0.sh;
})
