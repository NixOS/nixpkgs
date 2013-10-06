{stdenv, fetchurl, pkgconfig, libsoup, glib, libxml2}:

stdenv.mkDerivation {
  name = "gssdp-0.12.1";

  src = fetchurl {
    url = mirror://gnome/sources/gssdp/0.12/gssdp-0.12.1.tar.xz;
    sha256 = "0irkbzaj9raais6zdnbj3ysjkmdqhmdvfn0p1sz6x0s9ab6b9b0n";
  };

  buildInputs = [pkgconfig libsoup glib libxml2];

  meta = {
    description = "GObject-based API for handling resource discovery and announcement over SSDP";
    homepage = http://www.gupnp.org/;
    license = "LGPL v2";
    platforms = stdenv.lib.platforms.all;
  };
}
