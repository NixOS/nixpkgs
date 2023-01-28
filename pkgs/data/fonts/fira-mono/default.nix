# when changing this expression convert it from 'fetchzip' to 'stdenvNoCC.mkDerivation'
{ lib, fetchzip }:

let version = "4.202";
in (fetchzip {
  name = "fira-mono-${version}";

  url = "https://github.com/mozilla/Fira/archive/${version}.zip";

  sha256 = "1ci3fxhdwabvfj4nl16pwcgqnh7s2slp8vblribk8zkpx8cbp1dj";

  meta = with lib; {
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
}).overrideAttrs (_: {
  postFetch = ''
    mkdir -p $out/share/fonts
    unzip -j $downloadedFile Fira-${version}/otf/FiraMono\*.otf -d $out/share/fonts/opentype
  '';
})
