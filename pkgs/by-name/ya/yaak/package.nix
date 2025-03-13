{
  appimageTools,
  fetchurl,
  lib,
}:
appimageTools.wrapType2 rec {
  pname = "yaak";
  version = "2025.1.2";

  src = fetchurl {
    url = "https://github.com/mountain-loop/yaak/releases/download/v${version}/${pname}_${version}_amd64.AppImage";
    hash = "sha256-daUB2BW0y+6TYL6V591Yx/9JtgLdyuKEhCPjfG5L4WQ=";
  };

  contents = appimageTools.extract {
    inherit pname version src;
    postExtract = ''
      substituteInPlace $out/yaak.desktop --replace-fail 'yaak-app' 'yaak'
    '';
  };

  extraInstallCommands = ''
    install -Dm444 ${contents}/yaak.desktop $out/share/applications/yaak.desktop
    for size in "32x32" "128x128" "256x256@2"; do
      install -Dm444 ${contents}/usr/share/icons/hicolor/$size/apps/yaak-app.png $out/share/icons/hicolor/$size/apps/yaak.png
    done
  '';

  meta = {
    description = "Desktop API client for organizing and executing REST, GraphQL, and gRPC requests";
    homepage = "https://yaak.app/";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ redyf ];
    mainProgram = "yaak";
    platforms = [ "x86_64-linux" ];
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
  };
}
