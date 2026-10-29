{
  fetchurl,
  appimageTools,
  lib,
}:

let
  pname = "trucky";
  version = "3.8.2";

  src = fetchurl {
    url = "https://web.archive.org/web/20260328182310/https://client-download.truckyapp.com/linux/latest/Trucky.AppImage";
    hash = "sha256-8F6tIyooqzjgH2+qHsaoFwJkFzzW07fjqK9znDW/AyA=3";
  };

  appimageContents = appimageTools.extract { inherit pname version src; };
in
appimageTools.wrapType2 rec {
  inherit pname version src;

  extraBwrapArgs = [ "--setenv QT_QPA_PLATFORM xcb" ];

  extraInstallCommands = ''
    install -Dm444 ${appimageContents}/trucky-electron.desktop $out/share/applications/trucky-electron.desktop
    substituteInPlace $out/share/applications/trucky-electron.desktop \
      --replace-fail 'Exec=AppRun' 'Exec=${pname}'

    install -Dm444 ${appimageContents}/trucky-electron.png $out/share/icons/hicolor/48x48/apps/trucky-electron.png
  '';

  meta = {
    description = "The Virtual Trucker Companion";
    homepage = "https://truckyapp.com/";
    downloadPage = "https://truckyapp.com/client-download-linux";
    license = lib.licenses.unfree;
    maintainers = [ lib.maintainers.liamthexpl0rer ];
    platforms = lib.platforms.all;
  };
}
