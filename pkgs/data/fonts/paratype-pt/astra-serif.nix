{ lib, stdenvNoCC, fetchzip }:

stdenvNoCC.mkDerivation rec {
  pname = "paratype-pt-astra-serif";
  version = "1.003";

  src = fetchzip {
    urls = [
      "https://astralinux.ru/information/fonts-astra/font-ptastra-serif-ver1003.zip"
    ];
    stripRoot = false;
    hash = "sha256-P8jJ8v1/NTY3mW6whMyQlW0uRkfHUAx5cl17lhw3aDE=";
  };

  installPhase = ''
    runHook preInstall

    install -Dm644 *.ttf -t $out/share/fonts/truetype

    runHook postInstall
  '';

  meta = with lib; {
    homepage = "https://www.paratype.ru/fonts/pt/pt-astra-serif";
    description = "Serif font that is a metric analog of Times New Roman";

    license = licenses.ofl;

    platforms = platforms.all;
    maintainers = with maintainers; [ mxkrsv ];
  };
}
