{ stdenv, fetchurl, pkgconfig, glib, libsigcxx }:

let
  ver_maj = "2.44";
  ver_min = "0";
in
stdenv.mkDerivation rec {
  name = "glibmm-${ver_maj}.${ver_min}";

  src = fetchurl {
    url = "mirror://gnome/sources/glibmm/${ver_maj}/${name}.tar.xz";
    sha256 = "1a1fczy7hcpn24fglyn4i79f4yjc8s50is70q03mb294bm1c02hv";
  };

  nativeBuildInputs = [ pkgconfig ];
  propagatedBuildInputs = [ glib libsigcxx ];

  #doCheck = true; # some tests need network

  meta = {
    description = "C++ interface to the GLib library";

    homepage = http://gtkmm.org/;

    license = stdenv.lib.licenses.lgpl2Plus;

    maintainers = with stdenv.lib.maintainers; [urkud raskin];
    platforms = stdenv.lib.platforms.unix;
  };
}
