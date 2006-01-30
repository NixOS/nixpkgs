{stdenv, fetchurl, pkgconfig, libX11, libXext, libXt}:

stdenv.mkDerivation {
  name = "libXp-6.2.0-cvs";
  src = fetchurl {
    url = http://nix.cs.uu.nl/dist/tarballs/libXp-6.2.0-cvs.tar.bz2;
    md5 = "e9e69235e00fb80c3b399507f2699b1e";
  };
  buildInputs = [pkgconfig libXt];
  propagatedBuildInputs = [libX11 libXext];
}
