{ lib, stdenvNoCC, fetchurl }:

stdenvNoCC.mkDerivation rec {
  pname = "scientifica";
  version = "2.3";

  src = fetchurl {
    url = "https://github.com/NerdyPepper/scientifica/releases/download/v${version}/scientifica.tar";
    hash = "sha256-8IV4aaDoRsbxddy4U90fEZ6henUhjmO38HNtWo4ein8=";
  };

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/fonts/truetype
    mkdir -p $out/share/fonts/misc
    install ttf/*.ttf $out/share/fonts/truetype
    install otb/*.otb $out/share/fonts/misc
    install bdf/*.bdf $out/share/fonts/misc

    runHook postInstall
  '';

  meta = with lib; {
    description = "Tall and condensed bitmap font for geeks";
    homepage = "https://github.com/NerdyPepper/scientifica";
    license = licenses.ofl;
    platforms = platforms.all;
    maintainers = with maintainers; [ moni ];
  };
}
