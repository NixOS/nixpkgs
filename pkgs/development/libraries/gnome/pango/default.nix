{input, stdenv, fetchurl, pkgconfig, x11, glib}:

assert pkgconfig != null && x11 != null && glib != null;
assert x11.buildClientLibs;

stdenv.mkDerivation {
  inherit (input) name src;
  buildInputs = [pkgconfig];
  propagatedBuildInputs = [x11 glib];
}
