{stdenv, fetchurl}:

stdenv.mkDerivation {
  name = "mpeg2dec-0.4.0b";
  src = fetchurl {
    url = http://catamaran.labs.cs.uu.nl/dist/tarballs/mpeg2dec-0.4.0b.tar.gz;
    md5 = "52d10ea80595ec83d8557ba7ac6dc8e6";
  };
}
