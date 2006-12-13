{stdenv, fetchurl}:

stdenv.mkDerivation {
  name = "aterm-2.4.2-fixes-2";
  src = fetchurl {
    url = http://losser.st-lab.cs.uu.nl/~eelco/dist/aterm-2.4.2-fixes.tar.bz2;
    md5 = "9ad8ed141d3e66a7689817789431c0cd";
  };
  meta = {
    homepage = http://www.cwi.nl/htbin/sen1/twiki/bin/view/SEN1/ATerm;
    license = "LGPL";
    description = "Library for manipulation of term data structures in C";
  };
#  unpackPhase = "while true; do sleep 1; echo y; done";
}
