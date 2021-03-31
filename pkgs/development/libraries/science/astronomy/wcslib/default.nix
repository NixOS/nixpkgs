{ lib, stdenv, fetchurl, flex }:

stdenv.mkDerivation rec {
  pname = "wcslib";
  version = "7.3.1";

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

  meta = with lib; {
    homepage = "https://www.atnf.csiro.au/people/mcalabre/WCS/";
    description = "World Coordinate System Library for Astronomy";
    longDescription = ''
      Library for world coordinate systems for spherical geometries
      and their conversion to image coordinate systems. This is the
      standard library for this purpose in astronomy.
    '';
    maintainers = with maintainers; [ hjones2199 ];
    license = licenses.lgpl3Plus;
    platforms = platforms.unix;
  };
}
