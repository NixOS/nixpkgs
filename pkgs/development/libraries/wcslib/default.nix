{ fetchurl,  stdenv, flex }:

stdenv.mkDerivation rec {
  version = "5.14";
  name = "wcslib-${version}";

  buildInputs = [ flex ];

  src = fetchurl {
    url = "ftp://ftp.atnf.csiro.au/pub/software/wcslib/${name}.tar.bz2";
    sha256 ="0zz3747m6gjzglgsqrrslwk2qkb6swsx8gmaxa459dvbcg914gsd";
  };

  enableParallelBuilding = true;

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
