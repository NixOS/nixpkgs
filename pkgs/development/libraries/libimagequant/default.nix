{ lib, stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  pname = "libimagequant";
  version = "2.13.1";

  src = fetchFromGitHub {
    owner = "ImageOptim";
    repo = pname;
    rev = version;
    sha256 = "1543h1i59k2hbj2g8shcl8fvhz2silipacynwjgw412r38hkr33j";
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
