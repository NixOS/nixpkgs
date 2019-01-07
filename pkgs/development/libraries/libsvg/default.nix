{ stdenv, fetchurl, pkgconfig, libpng, libjpeg, libxml2 }:

stdenv.mkDerivation rec {
  name = "libsvg-${version}";
  version = "0.1.4";

  buildInputs = [ pkgconfig libxml2 libpng libjpeg ];

  src = fetchurl {
      url = "http://cairographics.org/snapshots/libsvg-0.1.4.tar.gz";
      sha256 = "13xw0ka1wpzlpdzvds555rzwsf0g9pk1ns9q4fqp4sk75qlzjfsc";
  };

  # The function png_set_gray_1_2_4_to_8() was removed. It has been
  # deprecated since libpng-1.0.18 and 1.2.9, when it was replaced
  # with png_set_expand_gray_1_2_4_to_8()
  patchPhase = ''
    substituteInPlace src/svg_image.c --replace "png_set_gray_1_2_4_to_8" "png_set_expand_gray_1_2_4_to_8"
  '';

  meta = with stdenv.lib; {    
    description = "A library for parsing SVG files";
    homepage = http://cairographics.org/;
    license = with licenses; [ lgpl2Plus mpl10 ];
    platforms = platforms.unix;
    maintainers = with maintainers; [ kisonecat ];
  };
}
