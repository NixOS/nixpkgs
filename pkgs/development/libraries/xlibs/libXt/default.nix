{stdenv, fetchurl, pkgconfig, libX11, libSM}:

stdenv.mkDerivation {
  name = "libXt-0.1.4-cvs";
  src = fetchurl {
    url = http://losser.st-lab.cs.uu.nl/~eelco/dist/libXt-0.1.4-cvs.tar.bz2;
    md5 = "65fd5ad321e846417845e80f44131ea5";
  };
  buildInputs = [pkgconfig];
  propagatedBuildInputs = [libX11 libSM];
}
