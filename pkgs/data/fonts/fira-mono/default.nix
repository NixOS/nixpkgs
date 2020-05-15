{ stdenv, fetchzip }:

fetchzip {
  name = "fira-mono-3.206";

  url = "https://github.com/mozilla/Fira/archive/4.106.zip";

  postFetch = ''
    mkdir -p $out/share/fonts
    unzip -j $downloadedFile Fira-4.106/otf/FiraMono\*.otf -d $out/share/fonts/opentype
  '';

  sha256 = "1ci3fxhdwabvfj4nl16pwcgqnh7s2slp8vblribk8zkpx8cbp1dj";

  meta = with stdenv.lib; {
    homepage = "https://mozilla.github.io/Fira/";
    description = "Monospace font for Firefox OS";
    longDescription = ''
      Fira Mono is a monospace font designed by Erik Spiekermann,
      Ralph du Carrois, Anja Meiners and Botio Nikoltchev of Carrois
      Type Design for Mozilla Firefox OS. Available in Regular,
      Medium, and Bold.
    '';
    license = licenses.ofl;
    maintainers = [ maintainers.rycee ];
    platforms = platforms.all;
  };
}
