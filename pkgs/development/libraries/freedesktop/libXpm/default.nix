{stdenv, fetchurl, pkgconfig, xproto, libX11}:

stdenv.mkDerivation {
  name = "libXpm-3.5.0";
  src = fetchurl {
    url = http://losser.st-lab.cs.uu.nl/~eelco/dist/libXpm-3.5.0-cvs.tar.bz2;
    md5 = "4695fdbc251e0b6dd1b984c51b85c781";
  };
  buildInputs = [pkgconfig];
  propagatedBuildInputs = [xproto libX11];
}
