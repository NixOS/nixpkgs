{ fetchurl,  stdenv, flex }:

stdenv.mkDerivation rec {
  version = "6.2";
  name = "wcslib-${version}";

  buildInputs = [ flex ];

  src = fetchurl {
    url = "ftp://ftp.atnf.csiro.au/pub/software/wcslib/${name}.tar.bz2";
    sha256 ="01fqckazhbfqqhyr0wd9vcks1m2afmsh83l981alxg2r54jgwkdv";
  };

  prePatch = ''
    substituteInPlace GNUmakefile --replace 2775 0775
    substituteInPlace C/GNUmakefile --replace 2775 0775
  '';

  enableParallelBuilding = true;

  meta = {
    description = "World Coordinate System Library for Astronomy";
    homepage = http://www.atnf.csiro.au/people/mcalabre/WCS/;

    longDescription = ''Library for world coordinate systems for
    spherical geometries and their conversion to image coordinate
    systems. This is the standard library for this purpose in
    astronomy.'';

    license = stdenv.lib.licenses.lgpl3Plus;
    platforms = stdenv.lib.platforms.unix;
  };
}
