{stdenv, fetchurl}:

stdenv.mkDerivation {
  name = "speex-1.0.5";
  src = fetchurl {
    url = http://nix.cs.uu.nl/dist/tarballs/speex-1.0.5.tar.gz;
    md5 = "01d6a2de0a88a861304bf517615dea79";
  };
}
