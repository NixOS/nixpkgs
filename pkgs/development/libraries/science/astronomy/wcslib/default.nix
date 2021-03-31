{ lib, stdenv, fetchurl, flex }:

stdenv.mkDerivation rec {
  pname = "wcslib";
  version = "7.5";

  src = fetchurl {
    url = "ftp://ftp.atnf.csiro.au/pub/software/wcslib/${pname}-${version}.tar.bz2";
    sha256 = "1536gmcpm6pckn9xrb6j8s4pm1vryjhzvhfaj9wx3jwxcpbdy0dw";
  };

  buildInputs = [ flex ];

  prePatch = ''
    substituteInPlace GNUmakefile --replace 2775 0775
    substituteInPlace C/GNUmakefile --replace 2775 0775
  '';

  enableParallelBuilding = true;

  meta = with lib; {
    homepage = "https://www.atnf.csiro.au/people/mcalabre/WCS/";
    description = "World Coordinate System library for astronomy";
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
