{stdenv, fetchurl}:

stdenv.mkDerivation {
  name = "aterm-2.4.2-fixes";
  src = fetchurl {
    url = http://losser.st-lab.cs.uu.nl/~eelco/dist/aterm-2.4.2-fixes.tar.bz2;
    md5 = "0622feaaa97c1e411e16f480f64e75fa";
  };
  patches = 
    (if stdenv ? isMinGW && stdenv.isMinGW then [./mingw-asm.patch] else []);
  meta = {
    homepage = http://www.cwi.nl/htbin/sen1/twiki/bin/view/SEN1/ATerm;
    license = "LGPL";
    description = "Library for manipulation of term data structures in C";
  };
}
