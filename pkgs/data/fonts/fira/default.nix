{ lib, mkFont, fetchFromGitHub }:

mkFont rec {
  pname = "fira";
  version = "4.202";

  src = fetchFromGitHub {
    owner = "mozilla";
    repo = "Fira";
    rev = version;
    sha256 = "116j26gdj5g1r124b4669372f7490vfjqw7apiwp2ggl0am5xd0w";
  };

  meta = with lib; {
    homepage = "https://mozilla.github.io/Fira/";
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
