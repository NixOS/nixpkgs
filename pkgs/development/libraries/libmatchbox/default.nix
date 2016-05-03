{ stdenv, fetchurl, libX11, libXext, libpng, libXft, libICE, pango, libjpeg}:

stdenv.mkDerivation rec {
  name = "libmatchbox-${version}";
  version = "1.11";

  buildInputs = [ libXft libICE pango libjpeg ];
  propagatedBuildInputs = [ libX11 libXext libpng ];

  src = fetchurl {
    url = "http://downloads.yoctoproject.org/releases/matchbox/libmatchbox/${version}/libmatchbox-${version}.tar.bz2";
    sha256 = "0lvv44s3bf96zvkysa4ansxj2ffgj3b5kgpliln538q4wd9ank15";
  };

  meta = {
    description = "Library of the matchbox X window manager";
    homepage = http://matchbox-project.org/;
    license = stdenv.lib.licenses.gpl2Plus;
  };
}
