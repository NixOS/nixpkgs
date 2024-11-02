{ lib
, stdenv
, fetchurl
, substituteAll
, pname
, version
, url
, sha256
, homepage
}:

stdenv.mkDerivation rec {
  inherit pname version;

  src = fetchurl {
    inherit url sha256;
  };

  patches = [
    # Fix buidling on platforms other than x86
    (substituteAll {
      src = ./configure.patch;
      msse = lib.optionalString stdenv.hostPlatform.isx86_64 "-msse";
    })
  ];

  doCheck = true;

  meta = {
    inherit homepage;
    description = "Subband sinusoidal modeling library for time stretching and pitch scaling audio";
    maintainers =  with lib.maintainers; [ yuu ];
    license = lib.licenses.gpl2;
    platforms = lib.platforms.all;
  };
}
