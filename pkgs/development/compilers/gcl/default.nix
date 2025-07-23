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
    teams = [ lib.teams.lisp ];
    license = licenses.gpl2;
    platforms = platforms.linux;
    broken = true; # 2025-01-21; to check after 2.7.0 is tagged
  };
}
