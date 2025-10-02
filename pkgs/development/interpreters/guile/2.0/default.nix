{
  lib,
  stdenv,
  pkgsBuildBuild,
  fetchpatch,
  libunistring,
  libtool,
  buildGuile,
}:

buildGuile {
  version = "2.0.13";
  srcHash = "sha256-7oBzxFgrtPBkEkUv313RharmB0QfExPIJPRL3WaLC94=";

  patches = [
    # Small fixes to Clang compiler
    ./clang.patch
    # Self-explanatory
    ./disable-gc-sensitive-tests.patch
    # RISC-V endianness
    ./riscv.patch
    # Fixes stability issues with 00-repl-server.test
    (fetchpatch {
      url = "https://git.savannah.gnu.org/cgit/guile.git/patch/?id=2fbde7f02adb8c6585e9baf6e293ee49cd23d4c4";
      hash = "sha256-+xwK/3BYdqV7tmS1/eYgBdPxZjG19PMHwNHGwCsNzFw=";
    })
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    ./filter-mkostemp-darwin.patch
    (fetchpatch {
      url = "https://gitlab.gnome.org/GNOME/gtk-osx/raw/52898977f165777ad9ef169f7d4818f2d4c9b731/patches/guile-clocktime.patch";
      hash = "sha256-BwgdtWvRgJEAnzqK2fCQgRHU0va50VR6SQfJpGzjm4s=";
    })
  ];

  depsBuildBuild = lib.optional (
    stdenv.hostPlatform != stdenv.buildPlatform
  ) pkgsBuildBuild.guile_2_0;

  enableParallelBuilding = true;

  env = lib.optionalAttrs (!stdenv.hostPlatform.isLinux) {
    # Work around <https://bugs.gnu.org/14201>.
    SHELL = stdenv.shell;
    CONFIG_SHELL = stdenv.shell;
  };

  postInstall = ''
    sed -i "$out/lib/pkgconfig/guile"-*.pc    \
        -e "s|-lunistring|-L${libunistring}/lib -lunistring|g ;
            s|^Cflags:\(.*\)$|Cflags: -I${libunistring.dev}/include \1|g ;
            s|-lltdl|-L${libtool.lib}/lib -lltdl|g ;
            s|includedir=$out|includedir=$dev|g
            "
  '';

  meta.maintainers = [ lib.maintainers.ludo ];
}
