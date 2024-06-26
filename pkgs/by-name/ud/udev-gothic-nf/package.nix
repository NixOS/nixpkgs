{ lib, stdenvNoCC, fetchzip }:

stdenvNoCC.mkDerivation rec {
  pname = "udev-gothic-nf";
  version = "1.3.1";

  src = fetchzip {
    url = "https://github.com/yuru7/udev-gothic/releases/download/v${version}/UDEVGothic_NF_v${version}.zip";
    hash = "sha256-4392vZX5CWg+tEpti1N+WQSx4ES5ZXoSiow6ufxqmsY=";
  };

  installPhase = ''
    runHook preInstall
    install -Dm644 *.ttf -t $out/share/fonts/${pname}
    runHook postInstall
  '';

  meta = with lib; {
    description = "Programming font that combines BIZ UD Gothic, JetBrains Mono and nerd-fonts";
    homepage = "https://github.com/yuru7/udev-gothic";
    license = licenses.ofl;
    maintainers = with maintainers; [ haruki7049 ];
    platforms = platforms.all;
  };
}
