{ lib, stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  pname = "libimagequant";
  version = "2.17.0";

  src = fetchFromGitHub {
    owner = "ImageOptim";
    repo = pname;
    rev = version;
    sha256 = "sha256-ZoBCZsoUO66X4sDbMO89g4IX5+jqGMLGR7aC2UwD2tE=";
  };

  preConfigure = ''
    patchShebangs ./configure
  '';

  configureFlags = lib.optionals (!stdenv.hostPlatform.isx86) [ "--disable-sse" ];

  meta = with lib; {
    homepage = "https://pngquant.org/lib/";
    description = "Image quantization library";
    longDescription = "Small, portable C library for high-quality conversion of RGBA images to 8-bit indexed-color (palette) images.";
    license = licenses.gpl3Plus;
    platforms = platforms.unix;
    maintainers = with maintainers; [ ma9e marsam ];
  };
}
