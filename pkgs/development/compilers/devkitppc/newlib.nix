{ stdenv
, callPackage
, lib
, texinfo
, devkitPPC-gcc
}:

let
  sources = callPackage ./sources.nix { };
in stdenv.mkDerivation rec {
  pname = "devkitPPC-newlib";
  src = sources.newlib;
  inherit (src) version;

  patches = [
    "${sources.buildscripts}/dkppc/patches/newlib-${version}.patch"
  ];

  nativeBuildInputs = [
    texinfo
    devkitPPC-gcc
  ];

  __structuredAttrs = true;

  env = {
    inherit (devkitPPC-gcc.env)
      gcc_cv_libc_provides_ssp
      CFLAGS_FOR_TARGET
    ;
  };

  configureFlags = [
    "--target=${sources.target}"
    "--enable-newlib-mb"
    "--enable-newlib-register-fini"
  ];

  preConfigure = ''
    mkdir ../build
    cd ../build
    configureScript=../$sourceRoot/configure
  '';

  enableParallelBuilding = true;

  passthru = {
    incdir = "/${sources.target}/include";
    libdir = "/${sources.target}/lib";
  };

  meta = {
    description = "a C library intended for use on embedded systems (devkitPPC)";
    homepage = "https://sourceware.org/newlib/";
    # arch has "bsd" while gentoo has "NEWLIB LIBGLOSS GPL-2" while COPYING has "gpl2"
    # there are 5 copying files in total
    # COPYING
    # COPYING.LIB
    # COPYING.LIBGLOSS
    # COPYING.NEWLIB
    # COPYING3
    license = lib.licenses.gpl2Plus;
    maintainers = [ lib.maintainers.novenary ];
  };
}
