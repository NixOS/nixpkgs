{ stdenv, fetchurl }:
stdenv.mkDerivation {
  name = "libestr-0.1.9";
  src = fetchurl {
    url = http://libestr.adiscon.com/files/download/libestr-0.1.9.tar.gz;
    sha256 = "06km9mlw5qq4aa7503l81d0qcghzl0n3lh0z41r1xjpa04nnwb42";
  };
}
