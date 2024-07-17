{
  lib,
  stdenvNoCC,
  fetchzip,
}:

stdenvNoCC.mkDerivation rec {
  pname = "udev-gothic";
  version = "1.3.1";

  src = fetchzip {
    url = "https://github.com/yuru7/udev-gothic/releases/download/v${version}/UDEVGothic_v${version}.zip";
    hash = "sha256-W1ekR3fWuS/ks1reCBAvZ5lR+aGh9qfaxn80Q2KlRM0=";
  };

  installPhase = ''
    runHook preInstall
    install -Dm644 *.ttf -t $out/share/fonts/${pname}
    runHook postInstall
  '';

  meta = with lib; {
    description = "A programming font that combines BIZ UD Gothic and JetBrains Mono";
    homepage = "https://github.com/yuru7/udev-gothic";
    license = licenses.ofl;
    maintainers = with maintainers; [ haruki7049 ];
    platforms = platforms.all;
  };
}
