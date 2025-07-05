{
  appimageTools,
  fetchurl,
  runCommand,
  lib,
  makeDesktopItem,
  copyDesktopItems,
  imagemagick,
}:
let
  icon =
    runCommand "xnviewmp-icon.png"
      {
        nativeBuildInputs = [ imagemagick ];
        src = fetchurl {
          url = "https://www.xnview.com/img/app-xnsoft-360.webp";
          hash = "sha256-wIzF/WOsPcrYFYC/kGZi6FSJFuErci5EMONjrx1VCdQ=";
        };
      }
      ''
        convert $src $out
      '';
in
appimageTools.wrapType2 rec {
  pname = "xnviewmp";
  version = "1.9.0";

  src = fetchurl {
    url = "https://download.xnview.com/old_versions/XnView_MP/XnView_MP-${version}.glibc2.17-x86_64.AppImage";
    hash = "sha256-lj6yLxg6VsNq4/3nZG8QuYYL+N+XRlpaN1Lmi307b8Q=";
  };

  nativeBuildInputs = [
    copyDesktopItems
  ];

  desktopItems = [
    (makeDesktopItem {
      name = "xnviewmp";
      desktopName = "XnView MP";
      exec = "xnviewmp %F";
      icon = "xnviewmp";
      comment = "An efficient multimedia viewer, browser and converter";
      categories = [ "Graphics" ];
    })
  ];

  extraPkgs = pkgs: [
    pkgs.qt5.qtbase
  ];

  extraInstallCommands = ''
    install -m 444 -D ${icon} $out/share/icons/hicolor/512x512/apps/xnviewmp.png
  '';

  meta = {
    description = "Efficient multimedia viewer, browser and converter";
    changelog = "https://www.xnview.com/mantisbt/changelog_page.php";
    homepage = "https://www.xnview.com/en/xnviewmp/";
    downloadPage = "https://download.xnview.com/old_versions/XnView_MP/";
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
    license = lib.licenses.unfree;
    mainProgram = "xnviewmp";
    maintainers = with lib.maintainers; [ oddlama ];
    platforms = lib.platforms.linux;
  };
}
