{stdenv, fetchurl, pkgconfig, xproto, libX11}:

stdenv.mkDerivation {
  name = "libXpm-3.5.1";
  src = fetchurl {
    url = http://catamaran.labs.cs.uu.nl/dist/tarballs/libXpm-3.5.1.tar.bz2;
    md5 = "733e20a60c3343531b50bcc48348fd3e";
  };
  buildInputs = [pkgconfig];
  propagatedBuildInputs = [xproto libX11];
}
