{ stdenv, fetchFromGitHub, unzip }:

with stdenv;

let
  version = "2.12.2";
in
  mkDerivation {
    name = "libimagequant-${version}";
    src = fetchFromGitHub {
      owner = "ImageOptim";
      repo = "libimagequant";
      rev = "${version}";
      sha256 = "1k61ifcjbp2lcrwqidflj99inkyhpbrw0hl1nzq1rjp5dnw2y5lw";
    };

    preConfigure = ''
      patchShebangs ./configure
    '';

    meta = {
      homepage = https://pngquant.org/lib/;
      description = "Image quantization library";
      longDescription = "Small, portable C library for high-quality conversion of RGBA images to 8-bit indexed-color (palette) images.";
      license = lib.licenses.gpl3Plus;
      platforms = lib.platforms.unix;
      maintainers = with lib.maintainers; [ ma9e ];
    };
  }
