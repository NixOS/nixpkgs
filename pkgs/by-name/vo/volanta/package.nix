{
  appimageTools,
  fetchurl,
  lib,
  makeWrapper,
  writeShellScript,
  common-updater-scripts,
  nix-update,
}:
let
  pname = "volanta";
  version = "1.13.3";
  build = "cdb350c9";
  src = fetchurl {
    url = "https://cdn.volanta.app/software/volanta-app/${version}-${build}/volanta-${version}.AppImage";
    hash = "sha256-0q0ShXqN1xA4+bKOX5jebUV+pDh+BNok5WZLLPrq0ks=";
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
      --add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--ozone-platform-hint=auto --enable-features=WaylandWindowDecorations --wayland-text-input-version=3}}"
  '';

  passthru = {
    inherit src build;
    updateScript = writeShellScript "update-volanta" ''
      LATEST_YML=$(curl --fail --silent https://api.volanta.app/api/v1/ClientUpdate/latest-linux.yml)
      VERSION=$(echo "$LATEST_YML" | grep -E '^version:' | awk '{print $2}')
      BUILD=$(echo "$LATEST_YML" | grep -E 'url: .*/volanta-app/' | sed -E 's/.*volanta-app\/[0-9.]+-([0-9a-f]+)\/.*/\1/' | head -n1)
      ${lib.getExe' common-updater-scripts "update-source-version"} volanta $BUILD --version-key=build || true
      ${lib.getExe nix-update} volanta --version $VERSION
    '';
  };

  meta = {
    description = "Easy-to-use smart flight tracker that integrates all your flight data across all major flightsims";
    homepage = "https://volanta.app/";
    maintainers = with lib.maintainers; [ SirBerg ];
    mainProgram = "volanta";
    platforms = [ "x86_64-linux" ];
    license = lib.licenses.unfree;
  };
}
