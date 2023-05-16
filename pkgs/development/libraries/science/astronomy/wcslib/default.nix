{ lib, stdenv, fetchurl, flex }:

stdenv.mkDerivation rec {
  pname = "wcslib";
<<<<<<< HEAD
  version = "8.1";

  src = fetchurl {
    url = "ftp://ftp.atnf.csiro.au/pub/software/wcslib/${pname}-${version}.tar.bz2";
    sha256 = "sha256-K/I+b6vRC4rs/6VEMb8lqiJP8BnGCp5naqVlYfm0Ep4=";
=======
  version = "7.12";

  src = fetchurl {
    url = "ftp://ftp.atnf.csiro.au/pub/software/wcslib/${pname}-${version}.tar.bz2";
    sha256 = "sha256-nPjeUOEJqX+gRRHUER6NFL0KRAdxMqz3PmzwAp/pa9Q=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  nativeBuildInputs = [ flex ];

  enableParallelBuilding = true;

  outputs = [ "out" "man" ];

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
