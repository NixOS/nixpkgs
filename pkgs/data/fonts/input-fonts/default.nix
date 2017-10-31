{ stdenv, requireFile, unzip }:

stdenv.mkDerivation rec {
  name = "input-fonts-${version}";
  version = "2017-08-10"; # date of the download and checksum

  src = requireFile {
    name = "Input-Font.zip";
    url = "http://input.fontbureau.com/download/";
    sha256 = "07fkyvbb12agkb2kpnq2j45nycgbjvb4n1s5hjyqsipdh2z9zihq";
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
  outputHash = "0k7xqkgqldd110ch9s144ilh762q777qcjvg3plmrb9s6xiaqvvd";

  meta = with stdenv.lib; {
    description = "Fonts for Code, from Font Bureau";
    longDescrition = ''
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
    homepage = http://input.fontbureau.com;
    license = licenses.unfree;
    maintainers = with maintainers; [ romildo ];
    platforms = platforms.all;
  };
}
