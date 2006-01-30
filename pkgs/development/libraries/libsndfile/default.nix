{stdenv, fetchurl}:

stdenv.mkDerivation {
  name = "libsndfile-1.0.12";
  src = fetchurl {
    url = http://nix.cs.uu.nl/dist/tarballs/libsndfile-1.0.12.tar.gz;
    md5 = "03718b7b225b298f41c19620b8906108";
  };
}
