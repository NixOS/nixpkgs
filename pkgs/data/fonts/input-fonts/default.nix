{ lib, mkFont, requireFile, unzip }:

mkFont {
  pname = "input-fonts";
  version = "2019-11-25"; # date of the download and checksum

  src = requireFile {
    name = "Input-Font.zip";
    url = "https://input.fontbureau.com/download/";
    sha256 = "10rax2a7vzidcs7kyfg5lv5bwp9i7kvjpdcsd10p0517syijkp3b";
  };

  nativeBuildInputs = [ unzip ];
  sourceRoot = ".";

  meta = with lib; {
    description = "Fonts for Code, from Font Bureau";
    longDescription = ''
      Input is a font family designed for computer programming, data,
      and text composition. It was designed by David Jonathan Ross
      between 2012 and 2014 and published by The Font Bureau. It
      contains a wide array of styles so you can fine-tune the
      typography that works best in your editing environment.

      Input Mono is a monospaced typeface, where all characters occupy
      a fixed width. Input Sans and Serif are proportional typefaces
      that are designed with all of the features of a good monospace —
      generous spacing, large punctuation, and easily distinguishable
      characters — but without the limitations of a fixed width.
    '';
    homepage = "https://input.fontbureau.com";
    license = licenses.unfree;
    maintainers = with maintainers; [ romildo ];
    platforms = platforms.all;
  };
}
