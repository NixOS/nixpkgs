{ lib, stdenvNoCC, fetchzip }:

stdenvNoCC.mkDerivation rec {
  pname = "udev-gothic-font";
  version = "1.3.1";

  src = fetchzip {
    url = "https://github.com/yuru7/udev-gothic/releases/download/v${version}/UDEVGothic_v${version}.zip";
    sha256 = "1ka4lmi46d3zqvdagxm1l7wm36b75w80ipjsngj2zffnfx3s8msv";
  };

  installPhase = ''
    runHook preInstall

    install -Dm644 *.ttf -t $out/share/fonts/udev-gothic

    runHook postInstall
  '';

  meta = with lib; {
    description = "A programming font that combines BIZ UD Gothic and JetBrains Mono";
    homepage = "https://github.com/yuru7/udev-gothic";
    license = licenses.ofl;
    platforms = platforms.all;
    maintainers = with maintainers; [ haruki7049 ];
  };
}
