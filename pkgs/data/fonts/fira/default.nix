{stdenv, fetchurl, unzip }:

stdenv.mkDerivation rec {
  name = "fira-3.111";

  src = fetchurl {
    url = "http://www.carrois.com/wordpress/downloads/fira_3_1/FiraFonts3111.zip";
    sha256 = "3ced3df236b0b0eec1b390885c53ac02f3e3f830e9449414230717334a0b2457";
  };

  buildInputs = [unzip];
  phases = [ "unpackPhase" "installPhase" ];

  installPhase = ''
    mkdir -p $out/share/fonts/opentype
    find . -name "*.otf" -exec cp -v {} $out/share/fonts/opentype \;
  '';

  meta = with stdenv.lib; {
    homepage = http://www.carrois.com/fira-3-1/;
    description = "Sans-serif and monospace font for Firefox OS";
    longDescription = ''
      Fira Sans is a sans-serif font designed by Erik Spiekermann,
      Ralph du Carrois, Anja Meiners and Botio Nikoltchev of Carrois
      Type Design for Mozilla Firefox OS.  It is closely related to
      Spiekermann's FF Meta typeface.  Available in Two, Four, Eight,
      Hair, Thin, Ultra Light, Extra Light, Light, Book, Regular,
      Medium, Semi Bold, Bold, Extra Bold, Heavy weights with
      corresponding italic versions.  Fira Mono is a matching
      monospace variant of Fira Sans.  It is available in regular, and
      bold weights.
    '';
    license = licenses.ofl;
    platforms = platforms.all;
  };
}
