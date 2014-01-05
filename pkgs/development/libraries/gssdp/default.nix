{stdenv, fetchurl, pkgconfig, libsoup, glib, libxml2}:

stdenv.mkDerivation {
  name = "gssdp-0.12.2.1";

  src = fetchurl {
    url = mirror://gnome/sources/gssdp/0.12/gssdp-0.12.2.1.tar.xz;
    sha256 = "0544f9nv6dpnfd0qbmxm8xwqjh8dafcmf3vlzkdly12xh5bs52lj";
  };

  buildInputs = [pkgconfig libsoup glib libxml2];

  meta = {
    description = "GObject-based API for handling resource discovery and announcement over SSDP";
    homepage = http://www.gupnp.org/;
    license = "LGPL v2";
    platforms = stdenv.lib.platforms.all;
  };
}
