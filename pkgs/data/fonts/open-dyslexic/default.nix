{ lib, fetchzip }:

let
  version = "2016-06-23";
in fetchzip {
  name = "open-dyslexic-${version}";

  url = https://github.com/antijingoist/open-dyslexic/archive/20160623-Stable.zip;

  postFetch = ''
    mkdir -p $out/share/{doc,fonts}
    unzip -j $downloadedFile \*.otf       -d $out/share/fonts/opentype
    unzip -j $downloadedFile \*/README.md -d $out/share/doc/open-dyslexic
  '';

  sha256 = "1vl8z5rknh2hpr2f0v4b2qgs5kclx5pzyk8al7243k5db82a2cyi";

  meta = with lib; {
    homepage = https://opendyslexic.org/;
    description = "Font created to increase readability for readers with dyslexia";
    license = "Bitstream Vera License (https://www.gnome.org/fonts/#Final_Bitstream_Vera_Fonts)";
    platforms = platforms.all;
    maintainers = [maintainers.rycee];
  };
}
