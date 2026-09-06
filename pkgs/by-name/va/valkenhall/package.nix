{
  lib,
  appimageTools,
  fetchurl,
}:
let
  pname = "valkenhall";
  version = "0.31.2";

  src = fetchurl {
    url = "https://downloads.valkenhall.com/Valkenhall-${version}-x64.AppImage";
    hash = "sha256-wOf2fwo1R4+LeXCVTOVLmkHCZvUiBLPfNrKtxIfFi9o=";
  };

  appimageContents = appimageTools.extract { inherit pname version src; };
in
appimageTools.wrapType2 {
  inherit pname version src;

  extraInstallCommands = ''
    install -m 444 -D ${appimageContents}/valkenhall.desktop -t $out/share/applications
    substituteInPlace $out/share/applications/valkenhall.desktop \
      --replace-fail 'Exec=AppRun' 'Exec=valkenhall'
    install -m 444 -D ${appimageContents}/valkenhall.png -t $out/share/icons/hicolor/512x512/apps
  '';

  meta = {
    homepage = "https://valkenhall.com";
    description = "The ultimate online platform for Sorcery: Contested Realm";
    license = lib.licenses.unfree;
    maintainers = with lib.maintainers; [
      dave12311
    ];
    platforms = [ "x86_64-linux" ];
    mainProgram = "valkenhall";
  };
}
