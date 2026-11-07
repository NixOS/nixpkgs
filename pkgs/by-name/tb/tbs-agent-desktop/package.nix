{
  lib,
  appimageTools,
  fetchzip,
}:
let
  pname = "tbs-agent-desktop";
  version = "4.5.1";

  src = fetchzip {
    # upstream only publishes this mutable "latest" URL and the pinned version is
    # taken from the AppImage filename inside the zip.
    # we could snapshot this using the wayback machine.
    url = "https://agent.team-blacksheep.com/agent/TBS-Agent-v4-latest-linux.zip";
    hash = "sha256-XHdk9rqe34WX+ajPEC3yHrwCWD9eX3dusfjwgGXb3qM=";
    stripRoot = false;
    # The AppImage filename contains a space, which appimageTools cannot handle.
    postFetch = ''
      mv "$out/TBS Agent-${version}.AppImage" $out/tbs-agent-desktop.AppImage
    '';
  };

  appimageContents = appimageTools.extract {
    inherit pname version;
    src = "${src}/tbs-agent-desktop.AppImage";
  };
in
appimageTools.wrapType2 {
  inherit pname version;
  src = "${src}/tbs-agent-desktop.AppImage";

  extraInstallCommands = ''
    install -Dm444 ${appimageContents}/@tbsagent.desktop \
      $out/share/applications/tbs-agent-desktop.desktop
    install -Dm444 ${appimageContents}/usr/share/icons/hicolor/512x512/apps/@tbsagent.png \
      $out/share/icons/hicolor/512x512/apps/tbs-agent-desktop.png
    substituteInPlace $out/share/applications/tbs-agent-desktop.desktop \
      --replace-fail 'Exec=AppRun --no-sandbox %U' 'Exec=tbs-agent-desktop %U' \
      --replace-fail 'Icon=@tbsagent' 'Icon=tbs-agent-desktop'
  '';

  meta = {
    description = "The one-stop Software for updating and configuring your TBS gear";
    homepage = "https://www.team-blacksheep.com/products/prod:agentx";
    downloadPage = "https://www.team-blacksheep.com/download";
    license = lib.licenses.unfree;
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    mainProgram = "tbs-agent-desktop";
    maintainers = with lib.maintainers; [ cl0vr ];
    platforms = [ "x86_64-linux" ];
  };
}
