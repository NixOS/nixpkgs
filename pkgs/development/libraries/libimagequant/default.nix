{ lib, stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  pname = "libimagequant";
  version = "2.15.1";

  src = fetchFromGitHub {
    owner = "ImageOptim";
    repo = pname;
    rev = version;
    sha256 = "sha256-ElMwLeUdrJeJJ9YoieCF/CUNcNMwj5WcjXmMW/nMyAw=";
  };

  preConfigure = ''
    patchShebangs ./configure
  '';

  configureFlags = lib.optionals (!stdenv.isi686 && !stdenv.isx86_64) [ "--disable-sse" ];

  meta = with lib; {
    homepage = "https://pngquant.org/lib/";
    description = "Image quantization library";
    longDescription = "Small, portable C library for high-quality conversion of RGBA images to 8-bit indexed-color (palette) images.";
    license = licenses.gpl3Plus;
    platforms = platforms.unix;
    maintainers = with maintainers; [ ma9e marsam ];
  };
}
