{stdenv, fetchurl}:

stdenv.mkDerivation {
  name = "panoramixext-1.1";
  src = fetchurl {
    url = http://catamaran.labs.cs.uu.nl/dist/tarballs/panoramixext-1.1.tar.bz2;
    md5 = "129f8623dc4f70188a015e3cbd7eae82";
  };
}
