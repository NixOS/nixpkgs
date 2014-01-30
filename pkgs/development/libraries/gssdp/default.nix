{stdenv, fetchurl, pkgconfig, libsoup, glib, libxml2}:

stdenv.mkDerivation {
  name = "gssdp-0.12.2.1";

  src = fetchurl {
    url = mirror://gnome/sources/gssdp/0.14/gssdp-0.14.6.tar.xz;
    sha256 = "1kgakr0rpdpm7nkp4ycka12nndga16wmzim79v1nbcc0j2wxxkws";
  };

  buildInputs = [pkgconfig libsoup glib libxml2];

  meta = {
    description = "GObject-based API for handling resource discovery and announcement over SSDP";
    homepage = http://www.gupnp.org/;
    license = "LGPL v2";
    platforms = stdenv.lib.platforms.all;
  };
}
