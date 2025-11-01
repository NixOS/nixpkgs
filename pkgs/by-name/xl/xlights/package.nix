{
  lib,
  appimageTools,
  fetchurl,
}:

appimageTools.wrapType2 rec {
  pname = "xlights";
  version = "2025.11";

  src = fetchurl {
    url = "https://github.com/smeighan/xLights/releases/download/${version}/xLights-${version}-x86_64.AppImage";
    hash = "sha256-k5HGk5t/ujPuOU/GlxhA+yKKXy0lq8YkxcQkTUVBYXM=";
  };

  appimageContents = appimageTools.extract { inherit pname version src; };

  extraInstallCommands = ''
    install -m 444 -D ${appimageContents}/xlights.desktop $out/share/applications/xlights.desktop
    install -m 444 -D ${appimageContents}/usr/share/icons/hicolor/256x256/apps/xlights.png \
      $out/share/icons/hicolor/256x256/apps/xlights.png
    substituteInPlace $out/share/applications/xlights.desktop \
      --replace-fail 'Exec=xLights' 'Exec=xlights'
  '';

  meta = {
    description = "Sequencer for lights with USB and E1.31 drivers";
    homepage = "https://xlights.org";
    license = lib.licenses.gpl3;
    maintainers = with lib.maintainers; [ kashw2 ];
    platforms = lib.platforms.linux;
    mainProgram = "xlights";
  };
}
