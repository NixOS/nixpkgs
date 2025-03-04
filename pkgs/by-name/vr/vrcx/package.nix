{
  lib,
  fetchurl,
  appimageTools,
  dotnet-runtime_9,
}:
let
  pname = "vrcx";
  version = "2025.03.01";
  filename = builtins.replaceStrings [ "." ] [ "" ] version;
  src = fetchurl {
    hash = "sha256-d+sqebPDZC0GWtd+5/R1KXIKUbpZ0k9YFupsf29IHCs=";
    url = "https://github.com/vrcx-team/VRCX/releases/download/v${version}/VRCX_${filename}.AppImage";
  };
  appimageContents = appimageTools.extract {
    inherit pname src version;
  };
in
appimageTools.wrapType2 rec {
  inherit pname version src;
  extraPkgs = pkgs: [ dotnet-runtime_9 ];
  extraInstallCommands = ''
    install -m 444 -D ${appimageContents}/vrcx.desktop \
      $out/share/applications/VRCX.desktop
    install -m 444 -D ${appimageContents}/usr/share/icons/hicolor/256x256/apps/vrcx.png \
      $out/share/icons/hicolor/256x256/apps/VRCX.png

    substituteInPlace $out/share/applications/VRCX.desktop \
      --replace-fail 'Exec=AppRun' 'Exec=${pname} --no-install --ozone-platform-hint=auto'
    substituteInPlace $out/share/applications/VRCX.desktop \
      --replace-fail 'Icon=VRCX' "Icon=$out/share/icons/hicolor/256x256/apps/VRCX.png"
  '';

  meta = {
    description = "Friendship management tool for VRChat";
    longDescription = ''
      VRCX is an assistant/companion application for VRChat that provides information about and helps you accomplish various things
      related to VRChat in a more convenient fashion than relying on the plain VRChat client (desktop or VR), or website alone.
    '';
    license = lib.licenses.mit;
    homepage = "https://github.com/vrcx-team/VRCX";
    downloadPage = "https://github.com/vrcx-team/VRCX/releases";
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    maintainers = with lib.maintainers; [ ShyAssassin ];
    platforms = lib.platforms.linux;
  };
}
