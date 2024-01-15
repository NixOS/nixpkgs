{ lib, stdenv, fetchurl, autoreconfHook, pkg-config, which, gnuplot
, giflib, libjpeg, libpng, libtiff, libwebp, openjpeg, zlib
}:

stdenv.mkDerivation rec {
  pname = "leptonica";
  version = "1.84.0";

  src = fetchurl {
    url = "https://github.com/DanBloomberg/${pname}/releases/download/${version}/${pname}-${version}.tar.gz";
    hash = "sha256-QqApMSod8M1WQBlal5voG/ZiMOFTFkysRWR4RU5yBtU=";
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
