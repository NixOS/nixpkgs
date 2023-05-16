{ lib, stdenv, fetchurl, autoreconfHook, pkg-config, which, gnuplot
, giflib, libjpeg, libpng, libtiff, libwebp, openjpeg, zlib
}:

stdenv.mkDerivation rec {
  pname = "leptonica";
<<<<<<< HEAD
  version = "1.83.1";

  src = fetchurl {
    url = "https://github.com/DanBloomberg/${pname}/releases/download/${version}/${pname}-${version}.tar.gz";
    hash = "sha256-jxhhXgdDr3339QmFxzDfzwyTVIBz0fVmIeQVaotU090=";
=======
  version = "1.83.0";

  src = fetchurl {
    url = "http://www.leptonica.org/source/${pname}-${version}.tar.gz";
    sha256 = "sha256-IGWR3VjPhO84CDba0TO1jJ0a+SSR9amCXDRqFiBEvP4=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  nativeBuildInputs = [ autoreconfHook pkg-config ];
  buildInputs = [ giflib libjpeg libpng libtiff libwebp openjpeg zlib ];
  enableParallelBuilding = true;

  nativeCheckInputs = [ which gnuplot ];

  # Fails on pngio_reg for unknown reason
  doCheck = false; # !stdenv.isDarwin;

  meta = {
    description = "Image processing and analysis library";
    homepage = "http://www.leptonica.org/";
    license = lib.licenses.bsd2; # http://www.leptonica.org/about-the-license.html
    platforms = lib.platforms.unix;
  };
}
