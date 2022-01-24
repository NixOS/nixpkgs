{ lib, stdenv, fetchurl, libX11, libXext, libpng, libXft, libICE, pango, libjpeg}:

stdenv.mkDerivation rec {
  pname = "libmatchbox";
  version = "1.11";

  buildInputs = [ libXft libICE pango libjpeg ];
  propagatedBuildInputs = [ libX11 libXext libpng ];
  NIX_LDFLAGS = "-lX11";

  src = fetchurl {
    url = "https://downloads.yoctoproject.org/releases/matchbox/libmatchbox/${version}/libmatchbox-${version}.tar.bz2";
    sha256 = "0lvv44s3bf96zvkysa4ansxj2ffgj3b5kgpliln538q4wd9ank15";
  };

  meta = {
    description = "Library of the matchbox X window manager";
    homepage = "http://matchbox-project.org/";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.unix;
  };
}
