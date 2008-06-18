{stdenv, fetchurl, pkgconfig, libsoup, glib, libxml2}:

stdenv.mkDerivation {
  name = "gssdp-0.6.1";
  src = fetchurl {
    url = http://www.gupnp.org/sources/gssdp/gssdp-0.6.1.tar.gz;
    sha256 = "1mla3s0p4vabrn4m7il02f1d1ily3712fjw4k9l3x89rqyi2qh7f";
  };

  buildInputs = [pkgconfig libsoup glib libxml2];

  meta = {
    description = "A GObject-based API for handling resource discovery and announcement over SSDP.";
    homepage = http://www.gupnp.org/;
    license = "LGPL v2";
  };
}
