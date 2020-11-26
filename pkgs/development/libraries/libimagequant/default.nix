{ stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  pname = "libimagequant";
  version = "2.13.0";

  src = fetchFromGitHub {
    owner = "ImageOptim";
    repo = pname;
    rev = version;
    sha256 = "12alfvq761nhdl927aj93yv3r6rzxlf7csdr28xgga7cz53fmrrp";
  };

  preConfigure = ''
    patchShebangs ./configure
  '';

  meta = with stdenv.lib; {
    homepage = "https://pngquant.org/lib/";
    description = "Image quantization library";
    longDescription = "Small, portable C library for high-quality conversion of RGBA images to 8-bit indexed-color (palette) images.";
    license = licenses.gpl3Plus;
    platforms = platforms.unix;
    maintainers = with maintainers; [ ma9e marsam ];
  };
}
