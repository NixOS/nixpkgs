{
  lib,
  stdenv,
  fetchurl,
  mpfr,
  m4,
  binutils,
  emacs,
  zlib,
  which,
  texinfo,
  libX11,
  xorgproto,
  libXi,
  gmp,
  libXext,
  libXt,
  libXaw,
  libXmu,
}:

assert stdenv ? cc;
assert stdenv.cc.isGNU;
assert stdenv.cc ? libc;
assert stdenv.cc.libc != null;

stdenv.mkDerivation rec {
  pname = "gcl";
  version = "2.6.14";

  src = fetchurl {
    url = "mirror://gnu/gcl/gcl-${version}.tar.gz";
    hash = "sha256-CfNBfFEqoXM6Y4gJ06Y6wpDuuUSL6CeV9bZoG9MHNFo=";
  };

  buildInputs = [
    mpfr
    m4
    binutils
    emacs
    gmp
    libX11
    xorgproto
    libXi
    libXext
    libXt
    libXaw
    libXmu
    zlib
    which
    texinfo
  ];

  configureFlags = [
    "--enable-ansi"
  ];

  meta = with lib; {
    description = "GNU Common Lisp compiler working via GCC";
    mainProgram = "gcl";
    maintainers = lib.teams.lisp.members;
    license = licenses.gpl2;
    platforms = platforms.linux;
  };
}
