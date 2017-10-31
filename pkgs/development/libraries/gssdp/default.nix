{ stdenv, fetchurl, pkgconfig, libsoup, glib }:

stdenv.mkDerivation rec {
  name = "gssdp-${version}";
  version = "1.0.1";

  src = fetchurl {
    url = "mirror://gnome/sources/gssdp/1.0/${name}.tar.xz";
    sha256 = "1qfj4gir1qf6v86z70ryzmjb75ns30q6zi5p89vhd3621gs6f7b0";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ libsoup ];
  propagatedBuildInputs = [ glib ];

  meta = with stdenv.lib; {
    description = "GObject-based API for handling resource discovery and announcement over SSDP";
    homepage = http://www.gupnp.org/;
    license = licenses.lgpl2;
    platforms = platforms.all;
  };
}
