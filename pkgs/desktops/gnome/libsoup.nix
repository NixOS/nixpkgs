{input, stdenv, fetchurl, pkgconfig, libxml2, glib
  , libproxy, GConf, sqlite}:

stdenv.mkDerivation {
  inherit (input) name src;
  buildInputs = [pkgconfig libxml2 glib libproxy 
    GConf sqlite];
}
