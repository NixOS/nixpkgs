{ lib, stdenv, requireFile, unzip }:

stdenv.mkDerivation {
  pname = "input-fonts";
  version = "2021-03-30"; # date of the download and checksum

  src = requireFile {
    name = "Input-Font.zip";
    url = "https://input.djr.com/download/";
    sha256 = "0g7b0iwbbfcmmp4pqq9cgw50p3k12kqqaq1fnqlxg30mx9xjj5wn";
  };

  nativeBuildInputs = [ unzip ];

  phases = [ "unpackPhase" "installPhase" ];

  sourceRoot = ".";

  installPhase = ''
    mkdir -p $out/share/fonts/truetype
    find Input_Fonts -name "*.ttf" -exec cp -a {} "$out"/share/fonts/truetype/ \;
    mkdir -p "$out"/share/doc
    cp -a *.txt "$out"/share/doc/
  '';

  outputHashAlgo = "sha256";
  outputHashMode = "recursive";
  outputHash = "jKljb+EaQd6CXzdXa3iJEeMHk7n6pDJ/aDlIOLmnSSk=";

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
    homepage = "https://input.djr.com/";
    license = licenses.unfree;
    maintainers = with maintainers; [ romildo ];
    platforms = platforms.all;
  };
}
