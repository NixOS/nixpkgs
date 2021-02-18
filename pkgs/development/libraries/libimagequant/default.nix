{ lib, stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  pname = "libimagequant";
  version = "2.14.0";

  src = fetchFromGitHub {
    owner = "ImageOptim";
    repo = pname;
    rev = version;
    sha256 = "sha256-XP/GeZC8TCgBPqtScY9eneZHFter1kdWf/yko0p2VYQ=";
  };

  preConfigure = ''
    patchShebangs ./configure
  '';

  meta = with lib; {
    homepage = "https://pngquant.org/lib/";
    description = "Image quantization library";
    longDescription = "Small, portable C library for high-quality conversion of RGBA images to 8-bit indexed-color (palette) images.";
    license = licenses.gpl3Plus;
    platforms = platforms.unix;
    maintainers = with maintainers; [ ma9e marsam ];
  };
}
