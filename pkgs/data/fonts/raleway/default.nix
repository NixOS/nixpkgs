{ lib, fetchzip, stdenvNoCC }:

stdenvNoCC.mkDerivation (self: {
  pname = "raleway";
  version = "4.101";

  src = fetchzip {
    url = "https://github.com/theleagueof/raleway/releases/download/${self.version}/Raleway-${self.version}.tar.xz";
    hash = "sha256-itNHIMoRjiaqYAJoDNetkCquv47VAfel8MAzwsd//Ww=";
  };

  installPhase = ''
    runHook preInstall

    install -D -m444 -t $out/share/fonts/truetype $src/static/TTF/*.ttf
    install -D -m444 -t $out/share/fonts/opentype $src/static/OTF/*.otf

    runHook postInstall
  '';

  meta = {
    description = "Raleway is an elegant sans-serif typeface family";
    longDescription = ''
      Initially designed by Matt McInerney as a single thin weight, it was
      expanded into a 9 weight family by Pablo Impallari and Rodrigo Fuenzalida
      in 2012 and iKerned by Igino Marini. In 2013 the Italics where added, and
      most recently — a variable version.

      It features both old style and lining numerals, standard and
      discretionary ligatures, a pretty complete set of diacritics, as well as
      a stylistic alternate inspired by more geometric sans-serif typefaces
      than its neo-grotesque inspired default character set.

      It also has a sister display family, Raleway Dots.
    '';
    homepage = "https://www.theleagueofmoveabletype.com/raleway";
    license = lib.licenses.ofl;
    maintainers = with lib.maintainers; [ minijackson Profpatsch ];
  };
})
