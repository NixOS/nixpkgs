{ fetchurl,  stdenv, flex }:

stdenv.mkDerivation rec {
  version = "5.12";
  name = "wcslib-${version}";

  buildInputs = [ flex ];

  src = fetchurl {
    url = "ftp://ftp.atnf.csiro.au/pub/software/wcslib/${name}.tar.bz2";
    sha256 ="1r4dz5514pba2d5cc2ydpnqm85xsvy65hlvzdqayl6sl40liizsh";
  };

  meta = {
    description = "World Coordinate System Library for Astronomy";
    homepage = http://www.atnf.csiro.au/people/mcalabre/WCS/;

    longDescription = ''Library for world coordinate systems for
    spherical geometries and their conversion to image coordinate
    systems. This is the standard library for this purpose in
    astronomy.'';

    license = stdenv.lib.licenses.lgpl3Plus;
  };
}
