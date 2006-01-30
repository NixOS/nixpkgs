{stdenv, fetchurl, python, pkgconfig, glib, gtk}:

stdenv.mkDerivation {
  name = "pygtk-2.6.1";
#  builder = ./builder.sh;
  src = fetchurl {
    url = http://nix.cs.uu.nl/dist/tarballs/pygtk-2.6.1.tar.bz2;
    md5 = "b4610829e4f57b5538dfa3b8f1fbe026";
  };
  buildInputs = [python pkgconfig glib gtk];
}
