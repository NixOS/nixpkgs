{
  lib,
  appimageTools,
  fetchurl,
  makeWrapper,
  gitUpdater,
}:

appimageTools.wrapType2 rec {
  pname = "tutanota-desktop";
  version = "309.250918.1";

  src = fetchurl {
    url = "https://github.com/tutao/tutanota/releases/download/tutanota-desktop-release-${version}/tutanota-desktop-linux.AppImage";
    hash = "sha256-cL9Q2d7U31nhrhR6oHLwlb/HJB/GfJDeH0G6JN+fIjY=";
  };

  extraPkgs = pkgs: [ pkgs.libsecret ];

  nativeBuildInputs = [ makeWrapper ];

  extraInstallCommands =
    let
      appimageContents = appimageTools.extract { inherit pname version src; };
    in
    ''
      install -Dm 444 ${appimageContents}/tutanota-desktop.desktop -t $out/share/applications
      install -Dm 444 ${appimageContents}/tutanota-desktop.png -t $out/share/pixmaps

      substituteInPlace $out/share/applications/tutanota-desktop.desktop \
        --replace 'Exec=AppRun' 'Exec=${pname}'

      wrapProgram $out/bin/tutanota-desktop \
        --add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--ozone-platform-hint=auto --enable-features=WaylandWindowDecorations --enable-wayland-ime=true}}"
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
    maintainers = with lib.maintainers; [
      awwpotato
      s0ssh
    ];
    mainProgram = "tutanota-desktop";
    platforms = [ "x86_64-linux" ];
  };
}
