{ lib, stdenvNoCC, fetchzip }:

stdenvNoCC.mkDerivation rec {
  pname = "paratype-pt-astra-sans";
  version = "1.002";

  src = fetchzip {
    urls = [
      "https://astralinux.ru/information/fonts-astra/font-ptastrasans-ttf-ver1002.zip"
    ];
    stripRoot = false;
    hash = "sha256-Jm8CJzMPq6VgTXgbN6QU78PS3Y0ekM8cSnveuI6xG4E=";
  };

  installPhase = ''
    runHook preInstall

    install -Dm644 *.ttf -t $out/share/fonts/truetype

    runHook postInstall
  '';

  meta = with lib; {
    homepage = "https://www.paratype.ru/fonts/pt/pt-astra-sans";
    description = "Sans font that is metrically coordinated with PT Astra Serif";

    license = licenses.ofl;

    platforms = platforms.all;
    maintainers = with maintainers; [ mxkrsv ];
  };
}
