{
  appimageTools,
  fetchurl,
  lib,
  xorg,
}:

appimageTools.wrapType2 rec {
  pname = "sylk";
  version = "3.7.0";

  src = fetchurl {
    url = "https://download.ag-projects.com/Sylk/Sylk-${version}-x86_64.AppImage";
    hash = "sha256-3lWWc3aSn+aKM/gX4v2suVbj5sZPKl1r36eQP3a2pNg=";
  };

  extraPkgs = pkgs: [
    xorg.libxshmfence
  ];

  appimageContents = appimageTools.extractType2 { inherit pname version src; };

  extraInstallCommands = ''
    install -Dm444 ${appimageContents}/sylk-electron.desktop -t $out/share/applications/
    install -Dm444 ${appimageContents}/sylk-electron.png -t $out/share/icons/hicolor/512x512/apps/

    substituteInPlace $out/share/applications/sylk-electron.desktop \
      --replace-fail 'Exec=AppRun --no-sandbox' 'Exec=${pname}'
  '';

  profile = ''
    export LC_ALL=C.UTF-8
  '';

  meta = {
    description = "Desktop client for SylkServer, a multiparty conferencing tool";
    homepage = "https://sylkserver.com/";
    license = lib.licenses.agpl3Plus;
    mainProgram = "sylk";
    maintainers = with lib.maintainers; [ zimbatm ];
    teams = with lib.teams; [ ngi ];
    platforms = [
      "i386-linux"
      "x86_64-linux"
    ];
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
  };
}
