{stdenv, fetchurl, lib, cmake, qt4}:

let
  pn = "qimageblitz";
  v = "0.0.4";
in

stdenv.mkDerivation {
  name = "${pn}-${v}";

  src = fetchurl {
    url = "mirror://sourceforge/${pn}/${pn}-${v}.tar.bz2";
    sha256 = "0pnaf3qi7rgkxzs2mssmslb3f9ya4cyx09wzwlis3ppyvf72j0p9";
  };

  buildInputs = [ cmake qt4 ];

  patches = [ ./qimageblitz-9999-exec-stack.patch ];

  meta = {
    description = "Graphical effect and filter library for KDE4";
    license = stdenv.lib.licenses.bsd2;
    homepage = "http://${pn}.sourceforge.net";
    platforms = stdenv.lib.platforms.linux;
  };
}
