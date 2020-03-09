{ fetchurl,  stdenv, flex }:

stdenv.mkDerivation rec {
  version = "7.1";
  pname = "wcslib";

  buildInputs = [ flex ];

  src = fetchurl {
    url = "ftp://ftp.atnf.csiro.au/pub/software/wcslib/${pname}-${version}.tar.bz2";
    sha256 ="05ji2v4la8h6azprb8x2zh6wrswxsq8cqw9zml0layc4nfg79fzh";
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
