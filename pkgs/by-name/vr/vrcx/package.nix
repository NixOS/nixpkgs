{
  lib,
  fetchurl,
  appimageTools,
  dotnet-runtime,
}:
let
  pname = "vrcx";
  version = "2025-01-27T00.10-0ee8137";
  src = fetchurl {
    url = "https://github.com/Natsumi-sama/VRCX/releases/download/${version}/VRCX_${version}.AppImage";
    hash = "sha256-kaQOME3jBLr7QJjc7rubNqFu3z+LmiP+UHe2EWYC7ek=";
  };
  appimageContents = appimageTools.extract {
    inherit pname src version;
  };
in
appimageTools.wrapType2 rec {
  inherit pname version src;
  extraPkgs = pkgs: [ dotnet-runtime ];
  extraInstallCommands = ''
    install -m 444 -D ${appimageContents}/vrcx.desktop $out/share/applications/vrcx.desktop
    install -m 444 -D ${appimageContents}/usr/share/icons/hicolor/256x256/apps/vrcx.png \
      $out/share/icons/hicolor/256x256/apps/vrcx.png
    substituteInPlace $out/share/applications/vrcx.desktop \
      --replace-fail 'Exec=AppRun' 'Exec=${pname}'
    # Fix icon path
    substituteInPlace $out/share/applications/vrcx.desktop \
      --replace-fail 'Icon=VRCX' "Icon=$out/share/icons/hicolor/256x256/apps/vrcx.png"
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
    platforms = [ "x86_64-linux" ];
  };
}
