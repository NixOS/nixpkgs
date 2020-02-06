{ fetchurl,  stdenv, flex }:

stdenv.mkDerivation rec {
  version = "6.4";
  pname = "wcslib";

  buildInputs = [ flex ];

  src = fetchurl {
    url = "ftp://ftp.atnf.csiro.au/pub/software/wcslib/${pname}-${version}.tar.bz2";
    sha256 ="003h23m6d5wcs29v2vbnl63f3z35k5x70lpsqlz5c9bp1bvizh8k";
  };

  prePatch = ''
    substituteInPlace GNUmakefile --replace 2775 0775
    substituteInPlace C/GNUmakefile --replace 2775 0775
  '';

  enableParallelBuilding = true;

  meta = {
    description = "World Coordinate System Library for Astronomy";
    homepage = https://www.atnf.csiro.au/people/mcalabre/WCS/;

    longDescription = ''Library for world coordinate systems for
    spherical geometries and their conversion to image coordinate
    systems. This is the standard library for this purpose in
    astronomy.'';

    license = stdenv.lib.licenses.lgpl3Plus;
    platforms = stdenv.lib.platforms.unix;
  };
}
