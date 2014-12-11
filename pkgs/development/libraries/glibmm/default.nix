{ stdenv, fetchurl, pkgconfig, glib, libsigcxx }:

let
  ver_maj = "2.42";
  ver_min = "0";
in
stdenv.mkDerivation rec {
  name = "glibmm-${ver_maj}.${ver_min}";

  src = fetchurl {
    url = "mirror://gnome/sources/glibmm/${ver_maj}/${name}.tar.xz";
    sha256 = "985083d97378d234da27a7243587cc0d186897a4b2d3c1286f794089be1a3397";
  };

  nativeBuildInputs = [ pkgconfig ];
  propagatedBuildInputs = [ glib libsigcxx ];

  #doCheck = true; # some tests need network

  meta = {
    description = "C++ interface to the GLib library";

    homepage = http://gtkmm.org/;

    license = stdenv.lib.licenses.lgpl2Plus;

    maintainers = with stdenv.lib.maintainers; [urkud raskin];
    platforms = stdenv.lib.platforms.linux;
  };
}
