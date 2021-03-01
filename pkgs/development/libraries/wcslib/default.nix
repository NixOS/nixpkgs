{ fetchurl,  lib, stdenv, flex }:

stdenv.mkDerivation rec {
  version = "7.3.1";
  pname = "wcslib";

  buildInputs = [ flex ];

  src = fetchurl {
    url = "ftp://ftp.atnf.csiro.au/pub/software/wcslib/${pname}-${version}.tar.bz2";
    sha256 ="0p0bp3jll9v2094a8908vk82m7j7qkjqzkngm1r9qj1v6l6j5z6c";
  };

  prePatch = ''
    substituteInPlace GNUmakefile --replace 2775 0775
    substituteInPlace C/GNUmakefile --replace 2775 0775
  '';

  enableParallelBuilding = true;

  meta = {
    description = "World Coordinate System Library for Astronomy";
    homepage = "https://www.atnf.csiro.au/people/mcalabre/WCS/";

    longDescription = ''Library for world coordinate systems for
    spherical geometries and their conversion to image coordinate
    systems. This is the standard library for this purpose in
    astronomy.'';

    license = lib.licenses.lgpl3Plus;
    platforms = lib.platforms.unix;
  };
}
