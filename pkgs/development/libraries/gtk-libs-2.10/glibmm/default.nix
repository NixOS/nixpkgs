{stdenv, fetchurl, pkgconfig, glib, libsigcxx}:

stdenv.mkDerivation {
  name = "glibmm-2.8.9";
  src = fetchurl {
    url = http://nix.cs.uu.nl/dist/tarballs/glibmm-2.8.9.tar.bz2;
    md5 = "6d23ba91546f51530421de5a1dc81fa8";
  };

  buildInputs = [pkgconfig glib libsigcxx];
}

