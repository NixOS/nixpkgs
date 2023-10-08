{ lib, stdenvNoCC, fetchzip }:

stdenvNoCC.mkDerivation rec {
  pname = "udev-gothic-nf-font";
  version = "1.3.1";

  src = fetchzip {
    url = "https://github.com/yuru7/udev-gothic/releases/download/v${version}/UDEVGothic_NF_v${version}.zip";
    sha256 = "1ilsdbybjflci897lrdr8khb212rgr9qnvaanhz6h2grjnypczz3";
  };

  installPhase = ''
    runHook preInstall

    install -Dm644 *.ttf -t $out/share/fonts/udev-gothic-nf

    runHook postInstall
  '';

  meta = with lib; {
    description = "A programming font that combines BIZ UD Gothic, JetBrains Mono and nerd-fonts";
    homepage = "https://github.com/yuru7/udev-gothic";
    license = licenses.ofl;
    platforms = platforms.all;
    maintainers = with maintainers; [ haruki7049 ];
  };
}
