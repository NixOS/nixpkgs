{
  lib,
  appimageTools,
  fetchurl,
  gitUpdater,
}:

appimageTools.wrapType2 rec {
  pname = "tutanota-desktop";
  version = "287.250602.0";

  src = fetchurl {
    url = "https://github.com/tutao/tutanota/releases/download/tutanota-desktop-release-${version}/tutanota-desktop-linux.AppImage";
    hash = "sha256-HHr2XaVYy0o/HdVcyGi1+5iHDhqlkFp0wlRpr7v61OA=";
  };

  extraPkgs = pkgs: [ pkgs.libsecret ];

  extraInstallCommands =
    let
      appimageContents = appimageTools.extract { inherit pname version src; };
    in
    ''
      install -Dm 444 ${appimageContents}/tutanota-desktop.desktop -t $out/share/applications
      install -Dm 444 ${appimageContents}/tutanota-desktop.png -t $out/share/pixmaps

      substituteInPlace $out/share/applications/tutanota-desktop.desktop \
        --replace 'Exec=AppRun' 'Exec=${pname}'
    '';

  passthru.updateScript = gitUpdater {
    url = "https://github.com/tutao/tutanota";
    rev-prefix = "tutanota-desktop-release-";
    allowedVersions = ".+\\.[0-9]{6}\\..+";
  };

  meta = {
    description = "Tuta official desktop client";
    homepage = "https://tuta.com/";
    changelog = "https://github.com/tutao/tutanota/releases/tag/tutanota-desktop-release-${version}";
    license = lib.licenses.gpl3Only;
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    maintainers = with lib.maintainers; [ ];
    mainProgram = "tutanota-desktop";
    platforms = [ "x86_64-linux" ];
  };
}
