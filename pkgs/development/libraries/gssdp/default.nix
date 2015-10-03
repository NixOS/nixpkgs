{ stdenv, fetchurl, pkgconfig, libsoup, glib }:

stdenv.mkDerivation {
  name = "gssdp-0.14.11";

  src = fetchurl {
    url = mirror://gnome/sources/gssdp/0.14/gssdp-0.14.11.tar.xz;
    sha256 = "0njkqr2y7c6linnw4wkc4y2vq5dfkpryqcinbzn0pzhr46psxxbv";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ libsoup ];
  propagatedBuildInputs = [ glib ];

  meta = {
    description = "GObject-based API for handling resource discovery and announcement over SSDP";
    homepage = http://www.gupnp.org/;
    license = stdenv.lib.licenses.lgpl2;
    platforms = stdenv.lib.platforms.all;
  };
}
