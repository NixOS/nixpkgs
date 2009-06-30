{stdenv, fetchurl, pkgconfig, libX11, gtk, intltool}:

stdenv.mkDerivation {
  name = "libwnck-2.26.1";
  src = fetchurl {
    url = mirror://gnome/desktop/2.26/2.26.2/sources/libwnck-2.26.1.tar.bz2;
    sha256 = "0c7l4p2iarl7vd69nskhqb76j8p5dvnf45rmm3a1c3ajrhmpnwsk";
  };
  buildInputs = [ pkgconfig libX11 gtk intltool ];
}
