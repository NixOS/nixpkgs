{
  appimageTools,
  fetchurl,
  lib,
  makeWrapper,
}:
let
  pname = "volanta";
  version = "1.10.11";
  src = fetchurl {
    url = "https://cdn.volanta.app/software/volanta-app/${version}-5495eec5/volanta-${version}.AppImage";
    hash = "sha256-DvAtgLe8eWG9sqxPaZGsk0CZWZci124bu2IFDU5Y1BQ=";
  };
  appImageContents = appimageTools.extract { inherit pname version src; };
in
appimageTools.wrapType2 {
  inherit pname version src;

  nativeBuildInputs = [ makeWrapper ];

  # Note: Volanta needs the env variable APPIMAGE=true to be set in order to work at all.
  extraInstallCommands = ''
    install -m 444 -D ${appImageContents}/volanta.desktop $out/share/applications/volanta.desktop
    install -m 444 -D ${appImageContents}/volanta.png \
      $out/share/icons/hicolor/1024x1024/apps/volanta.png
    substituteInPlace $out/share/applications/volanta.desktop \
      --replace-fail 'Exec=AppRun' 'Exec=env APPIMAGE=true volanta'
    wrapProgram $out/bin/volanta \
      --add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--ozone-platform-hint=auto --enable-features=WaylandWindowDecorations}}"
  '';
  meta = {
    description = "Easy-to-use smart flight tracker that integrates all your flight data across all major flightsims";
    homepage = "https://volanta.app/";
    maintainers = with lib.maintainers; [ SirBerg ];
    mainProgram = "volanta";
    platforms = [ "x86_64-linux" ];
    license = lib.licenses.unfree;
  };
}
