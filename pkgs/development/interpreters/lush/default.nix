{stdenv, fetchurl, libX11, xorgproto, indent, readline, gsl, freeglut, libGLU_combined, SDL
, blas, libbfd, intltool, gettext, zlib, libSM}:

stdenv.mkDerivation rec {
  baseName = "lush";
  version = "2.0.1";
  name = "${baseName}-${version}";

  src = fetchurl {
    url="mirror://sourceforge/project/lush/lush2/lush-2.0.1.tar.gz";
    sha256 = "02pkfn3nqdkm9fm44911dbcz0v3r0l53vygj8xigl6id5g3iwi4k";
  };

  buildInputs = [
    libX11 libSM xorgproto indent readline gsl freeglut libGLU_combined SDL blas libbfd
    intltool gettext zlib
  ];

  hardeningDisable = [ "pic" ];

  NIX_LDFLAGS=" -lz ";

  meta = {
    description = "Lisp Universal SHell";
    license = stdenv.lib.licenses.gpl2Plus ;
    maintainers = [ stdenv.lib.maintainers.raskin ];
    platforms = stdenv.lib.platforms.linux;
  };
}
