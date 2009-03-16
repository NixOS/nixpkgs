{stdenv, fetchurl, perl}:

stdenv.mkDerivation {
  name = "libical-0.43";
  src = fetchurl {
    url = http://superb-east.dl.sourceforge.net/sourceforge/freeassociation/libical-0.43.tar.gz;
    md5 = "5f0a1feb60894d0be537aefea5647474";
  };
  buildInputs = [ perl ];
}
