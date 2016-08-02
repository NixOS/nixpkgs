{ stdenv, fetchurl, unzip }:

stdenv.mkDerivation rec {
  name = "ipaexfont-003.01";

  src = fetchurl {
    url = "http://dl.ipafont.ipa.go.jp/IPAexfont/IPAexfont00301.zip";
    sha256 = "0nmfyh10rzkvp0qmrla0dahkmmxq47678y4v8fdm8fpdzmf0kpn7";
  };

  buildInputs = [ unzip ];

  installPhase = ''
    mkdir -p $out/share/fonts/opentype/
    cp *.ttf $out/share/fonts/opentype/
  '';

  meta = with stdenv.lib; {
    description = "Japanese font package with Mincho and Gothic fonts";
    longDescription = ''
      IPAex font is a Japanese font developed by the Information-technology
      Promotion Agency of Japan. It provides both Mincho and Gothic fonts,
      suitable for both display and printing.

      This is the successor to the IPA fonts.
    '';
    homepage = http://ipafont.ipa.go.jp/;
    license = licenses.ipa;
    maintainers = with maintainers; [ gebner ];
    platforms = with platforms; unix;
  };
}
