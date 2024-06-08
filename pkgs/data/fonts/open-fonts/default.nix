{ lib, stdenvNoCC, fetchurl }:

stdenvNoCC.mkDerivation rec {
  pname = "open-fonts";
  version = "0.7.0";

  src = fetchurl {
    url = "https://github.com/kiwi0fruit/open-fonts/releases/download/${version}/open-fonts.tar.xz";
    hash = "sha256-NJKbdrvgZz9G7mjAJYzN7rU/fo2xRFZA2BbQ+A56iPw=";
  };

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/fonts/truetype
    install *.ttf $out/share/fonts/truetype

    runHook postInstall
  '';

  meta = with lib; {
    description = "A collection of beautiful free and open source fonts";
    homepage = "https://github.com/kiwi0fruit/open-fonts";
    license = licenses.mit;
    platforms = platforms.all;
    maintainers = with maintainers; [ moni ];
  };
}
