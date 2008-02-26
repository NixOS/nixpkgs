{stdenv, fetchurl, pkgconfig, libsoup, glib, libxml2}:

stdenv.mkDerivation {
  name = "gssdp-0.4.2";
  src = fetchurl {
    url = http://www.gupnp.org/sources/gssdp/gssdp-0.4.2.tar.gz;
    sha256 = "0d4h494qkls3hl4cc8pjhlv34nwysa9bf7xsffbd59r4dxbqziwy";
  };

  buildInputs = [pkgconfig libsoup glib libxml2];

  meta = {
    description = "A GObject-based API for handling resource discovery and announcement over SSDP.";
    homepage = http://www.gupnp.org/;
    license = "LGPL v2";
  };
}
