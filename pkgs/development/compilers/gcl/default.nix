{
  lib,
  stdenv,
  fetchgit,
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
  version = "2.7.0pre34";

  src = fetchgit {
    # url = "mirror://gnu/gcl/gcl-${version}.tar.gz";
    url = "git://git.savannah.gnu.org/gcl.git/";
    rev = "Version_" + (lib.replaceStrings [ "." ] [ "_" ] version);
    hash = "sha256-9ftolkgr458yycV0BzCuUQkuDkFMcSdr2LdMgb5NXdc=";
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

  strictDeps = true;

  sourceRoot = "gcl/gcl";

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
