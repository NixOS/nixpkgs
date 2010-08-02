{ stdenv, fetchurl, pkgconfig, glib, libxml2, gssdp, libsoup, e2fsprogs }:
 
stdenv.mkDerivation {
  name = "gupnp-0.12";

  src = fetchurl {
    url = http://www.gupnp.org/sources/gupnp/gupnp-0.12.tar.gz;
    sha256 = "1sm1rqvx752nb3j1yl7h30kx2ymndkji8m73fxshjssmc6z40ayg";
  };

  buildInputs = [ pkgconfig glib libxml2 gssdp libsoup e2fsprogs ];
}
