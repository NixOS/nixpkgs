{ stdenv, fetchzip }:

fetchzip rec {
  name = "fira-4.106";

  url = https://github.com/mozilla/Fira/archive/4.106.zip;

  postFetch = ''
    mkdir -p $out/share/fonts
    unzip -j $downloadedFile Fira-4.106/otf/FiraSans\*.otf -d $out/share/fonts/opentype
  '';

  sha256 = "0c97nmihcq0ki7ywj8zn048a2bgrszc61lb9p0djfi65ar52jab4";

  meta = with stdenv.lib; {
    homepage = https://mozilla.github.io/Fira/;
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
