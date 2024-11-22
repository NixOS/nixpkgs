{ lib, stdenvNoCC, fetchzip }:

stdenvNoCC.mkDerivation rec {
  pname = "udev-gothic";
  version = "2.0.0";

  src = fetchzip {
    url = "https://github.com/yuru7/udev-gothic/releases/download/v${version}/UDEVGothic_v${version}.zip";
    hash = "sha256-VA0EaoK411qjX/nQBPkK0G9jS31nb7U8fNHgiWg4PQY=";
  };

  installPhase = ''
    runHook preInstall
    install -Dm644 *.ttf -t $out/share/fonts/udev-gothic
    runHook postInstall
  '';

  meta = with lib; {
    description = "Programming font that combines BIZ UD Gothic and JetBrains Mono";
    homepage = "https://github.com/yuru7/udev-gothic";
    license = licenses.ofl;
    maintainers = with maintainers; [ haruki7049 ];
    platforms = platforms.all;
  };
}
