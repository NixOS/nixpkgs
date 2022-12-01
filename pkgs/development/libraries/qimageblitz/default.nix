{lib, stdenv, fetchurl, cmake, qt4}:

stdenv.mkDerivation rec {
  pname = "qimageblitz";
  version = "0.0.4";

  src = fetchurl {
    url = "mirror://sourceforge/qimageblitz/qimageblitz-${version}.tar.bz2";
    sha256 = "0pnaf3qi7rgkxzs2mssmslb3f9ya4cyx09wzwlis3ppyvf72j0p9";
  };

  nativeBuildInputs = [ cmake ];
  buildInputs = [ qt4 ];

  patches = [ ./qimageblitz-9999-exec-stack.patch ];

  meta = {
    description = "Graphical effect and filter library for KDE4";
    license = lib.licenses.bsd2;
    homepage = "http://qimageblitz.sourceforge.net";
    platforms = lib.platforms.linux;
  };
}
