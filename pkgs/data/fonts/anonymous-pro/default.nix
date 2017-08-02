{ stdenv, fetchurl, unzip }:

stdenv.mkDerivation rec {
  name = "anonymousPro-${version}";
  version = "1.002";

  src = fetchurl {
    url = "http://www.marksimonson.com/assets/content/fonts/AnonymousPro-${version}.zip";
    sha256 = "1asj6lykvxh46czbal7ymy2k861zlcdqpz8x3s5bbpqwlm3mhrl6";
  };

  nativeBuildInputs = [ unzip ];
  phases = [ "unpackPhase" "installPhase" ];

  installPhase = ''
    mkdir -p $out/share/fonts/truetype
    mkdir -p $out/share/doc/${name}
    find . -name "*.ttf" -exec cp -v {} $out/share/fonts/truetype \;
    find . -name "*.txt" -exec cp -v {} $out/share/doc/${name} \;
  '';

  meta = with stdenv.lib; {
    homepage = https://www.marksimonson.com/fonts/view/anonymous-pro;
    description = "TrueType font set intended for source code";
    longDescription = ''
      Anonymous Pro (2009) is a family of four fixed-width fonts
      designed with coding in mind. Anonymous Pro features an
      international, Unicode-based character set, with support for
      most Western and Central European Latin-based languages, plus
      Greek and Cyrillic. It is designed by Mark Simonson.
    '';
    maintainers = with maintainers; [ raskin rycee ];
    license = licenses.ofl;
    platforms = platforms.all;
  };
}
