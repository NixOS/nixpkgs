{
  lib,
  stdenvNoCC,
  fetchurl,
}:

stdenvNoCC.mkDerivation {
  pname = "linja-pi-pu-lukin";
  version = "unstable-2021-10-29";

  src = fetchurl {
    url = "https://web.archive.org/web/20211029000000/https://jansa-tp.github.io/linja-pi-pu-lukin/PuLukin.otf";
    hash = "sha256-Mf7P9fLGiG7L555Q3wRaI/PRv/TIs0njLq2IzIbc5Wo=";
  };

  dontUnpack = true;

  installPhase = ''
    runHook preInstall

    install -D $src $out/share/fonts/opentype/linja-pi-pu-lukin.otf

    runHook postInstall
  '';

  meta = with lib; {
    description = "A sitelen pona font resembling the style found in Toki Pona: The Language of Good (lipu pu), by jan Sa.";
    homepage = "https://jansa-tp.github.io/linja-pi-pu-lukin/";
    license = licenses.unfree; # license is unspecified in repository
    platforms = platforms.all;
    maintainers = with maintainers; [ somasis ];
  };
}
