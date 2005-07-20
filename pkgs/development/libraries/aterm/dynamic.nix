{stdenv, fetchurl}:

stdenv.mkDerivation {
  name = "aterm-dynamic-2.3.2";
  src = fetchurl {
    url = http://catamaran.labs.cs.uu.nl/dist/stratego/aterm-2.3.2pre11665/aterm-2.3.2pre11665.tar.gz;
    md5 = "2eb01c044d765ded55f10e05756fec98";
  };
}
