{stdenv, fetchurl}:

stdenv.mkDerivation {
  name = "xf86vmext-2.2-cvs";
  src = fetchurl {
    url = http://losser.st-lab.cs.uu.nl/~eelco/dist/xf86vmext-2.2-cvs.tar.bz2;
    md5 = "5a5818accd51799626b8c6db429907e0";
  };
}
