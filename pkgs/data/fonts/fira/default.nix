{ stdenv, fetchurl, unzip }:

stdenv.mkDerivation rec {
  name = "fira-4.002";

  src = fetchurl {
    url = http://www.carrois.com/downloads/fira_4_0/FiraFonts4002.zip;
    sha256 = "1vh4hx8ffmh2p7mxxbcp5zbcz8kzpzxaggdqnhj5i4vi329n5hfw";
  };

  buildInputs = [unzip];
  phases = [ "unpackPhase" "installPhase" ];

  installPhase = ''
    mkdir -p $out/share/fonts/opentype
    find . -name "*.otf" -exec cp -v {} $out/share/fonts/opentype \;
  '';

  meta = with stdenv.lib; {
    homepage = http://www.carrois.com/fira-4-0/;
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
