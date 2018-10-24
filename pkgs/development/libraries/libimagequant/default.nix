{ stdenv, fetchFromGitHub, unzip }:

with stdenv;

let
  version = "2.12.1";
in
  mkDerivation {
    name = "libimagequant-${version}";
    src = fetchFromGitHub {
      owner = "ImageOptim";
      repo = "libimagequant";
      rev = "${version}";
      sha256 = "0r7zgsnhqci2rjilh9bzw43miwp669k6b7q16hdjzrq4nr0xpvbl";
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
