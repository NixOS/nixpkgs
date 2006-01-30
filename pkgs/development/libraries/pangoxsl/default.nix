{stdenv, fetchurl, pkgconfig, glib, pango}:

stdenv.mkDerivation {
  name = "pangoxsl-1.6.0.1";
  src = fetchurl {
    url = http://nix.cs.uu.nl/dist/tarballs/pangoxsl-1.6.0.1.tar.gz;
    md5 = "3c2b9b3b77c9b725a2914db90f61f24b";
  };

  buildInputs = [
    pkgconfig
    glib
    pango
  ];
}
