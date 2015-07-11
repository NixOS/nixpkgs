{ stdenv, fetchurl, unzip }:

stdenv.mkDerivation rec {
  name = "fira-4.104";

  src = fetchurl {
    url = http://www.carrois.com/downloads/fira_4_1/FiraFonts4104.zip;
    sha256 = "1i8l0x2wdx4pw7j52lgy8qcx0wqj0azwjiq0wa9kg26x78bdfk2d";
  };

  buildInputs = [unzip];
  phases = [ "unpackPhase" "installPhase" ];
  sourceRoot = "FiraFonts4104";

  installPhase = ''
    mkdir -p $out/share/fonts/opentype
    find . -name "*.otf" -exec cp -v {} $out/share/fonts/opentype \;
  '';

  meta = with stdenv.lib; {
    homepage = http://www.carrois.com/fira-4-1/;
    description = "Sans-serif font for Firefox OS";
    longDescription = ''
      Fira Sans is a sans-serif font designed by Erik Spiekermann,
      Ralph du Carrois, Anja Meiners and Botio Nikoltchev of Carrois
      Type Design for Mozilla Firefox OS.  It is closely related to
      Spiekermann's FF Meta typeface.  Available in Two, Four, Eight,
      Hair, Thin, Ultra Light, Extra Light, Light, Book, Regular,
      Medium, Semi Bold, Bold, Extra Bold, Heavy weights with
      corresponding italic versions.
    '';
    license = licenses.ofl;
    platforms = platforms.all;
  };
}
