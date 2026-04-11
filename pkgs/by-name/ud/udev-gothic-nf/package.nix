{
  lib,
  stdenvNoCC,
  fetchzip,
}:

stdenvNoCC.mkDerivation rec {
  pname = "udev-gothic-nf";
  version = "2.2.0";

  src = fetchzip {
    url = "https://github.com/yuru7/udev-gothic/releases/download/v${version}/UDEVGothic_NF_v${version}.zip";
    hash = "sha256-pX62FnoHTB6LmwI1wDHvjWsko82b8jOet3MzQrn/CXI=";
  };

  installPhase = ''
    runHook preInstall
    install -Dm644 *.ttf -t $out/share/fonts/udev-gothic-nf
    runHook postInstall
  '';

  meta = {
    description = "Programming font that combines BIZ UD Gothic, JetBrains Mono and nerd-fonts";
    homepage = "https://github.com/yuru7/udev-gothic";
    license = lib.licenses.ofl;
    maintainers = with lib.maintainers; [ haruki7049 ];
    platforms = lib.platforms.all;
  };
}
