{input, stdenv, fetchurl, pkgconfig, glib, libIDL, popt}:

assert pkgconfig != null && glib != null && libIDL != null
  && popt != null;

stdenv.mkDerivation {
  inherit (input) name src;
  buildInputs = [pkgconfig libIDL popt];
  propagatedBuildInputs = [glib];
}
