{stdenv, fetchurl, libX11, xproto, indent, readline, gsl, freeglut, mesa, SDL
, blas, binutils, intltool, gettext, zlib}:
let
  s = # Generated upstream information
  rec {
    baseName="lush";
    version="2.0.1";
    name="${baseName}-${version}";
    hash="02pkfn3nqdkm9fm44911dbcz0v3r0l53vygj8xigl6id5g3iwi4k";
    url="mirror://sourceforge/project/lush/lush2/lush-2.0.1.tar.gz";
    sha256="02pkfn3nqdkm9fm44911dbcz0v3r0l53vygj8xigl6id5g3iwi4k";
  };
  buildInputs = [
    libX11 xproto indent readline gsl freeglut mesa SDL blas binutils
    intltool gettext zlib
  ];
in
stdenv.mkDerivation {
  inherit (s) name version;
  inherit buildInputs;
  src = fetchurl {
    inherit (s) url sha256;
  };
  NIX_LDFLAGS=" -lz ";
  meta = {
    inherit (s) version;
    description = ''Lisp Universal SHell'';
    license = stdenv.lib.licenses.gpl2Plus ;
    maintainers = [stdenv.lib.maintainers.raskin];
    platforms = stdenv.lib.platforms.linux;
  };
}
