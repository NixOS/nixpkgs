{stdenv, fetchurl, pkgconfig, libX11, libXext, xf86vmext}:

stdenv.mkDerivation {
  name = "libXxf86vm-2.2.0-cvs";
  src = fetchurl {
    url = http://losser.st-lab.cs.uu.nl/~eelco/dist/libXxf86vm-2.2.0-cvs.tar.bz2;
    md5 = "0645a4f18ff720dbeabf5b2ff0fcd82a";
  };
  buildInputs = [pkgconfig];
  propagatedBuildInputs = [libX11 libXext xf86vmext];
}
