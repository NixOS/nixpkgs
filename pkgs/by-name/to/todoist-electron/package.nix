{
  lib,
  appimageTools,
  fetchurl,
  asar,
  makeWrapper,
}:

let
  pname = "todoist-electron";
  version = "9.18.0";

  src = fetchurl {
    url = "https://electron-dl.todoist.net/linux/Todoist-linux-${version}-x86_64-latest.AppImage";
    hash = "sha256-2X//beSpQ1rCqU4Wn5ELoxgfi2knFAJ2w1rn41TNP6g=";
  };

  appimageContents = appimageTools.extract {
    inherit pname version src;

    # Get rid of the autoupdater
    postExtract = ''
      ${lib.getExe asar} extract $out/resources/app.asar app
      sed -i 's/async isUpdateAvailable.*/async isUpdateAvailable(updateInfo) { return false;/g' app/node_modules/electron-updater/out/AppUpdater.js
      ${lib.getExe asar} pack app $out/resources/app.asar
    '';
  };
in
appimageTools.wrapAppImage {
  inherit pname version;
  src = appimageContents;

  extraPkgs = pkgs: [ pkgs.hidapi ];

  # Add desktop convencience stuff
  extraInstallCommands = ''
    install -D --mode 0644 ${appimageContents}/todoist.desktop -t $out/share/applications
    install -D --mode 0644 ${appimageContents}/todoist.png -t $out/share/pixmaps
    substituteInPlace $out/share/applications/todoist.desktop \
      --replace-fail "Exec=AppRun" "Exec=todoist-electron --" \
      --replace-fail "Exec=todoist" "Exec=todoist-electron --"

    . ${makeWrapper}/nix-support/setup-hook
    wrapProgram $out/bin/todoist-electron \
      --add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--ozone-platform-hint=auto --enable-features=WaylandWindowDecorations --enable-wayland-ime=true}}"
  '';

  meta = {
    description = "To-Do List App & Task Manager";
    homepage = "https://www.todoist.com";
    license = lib.licenses.unfree;
    mainProgram = "todoist-electron";
    maintainers = with lib.maintainers; [
      kylesferrazza
      pokon548
    ];
    platforms = [ "x86_64-linux" ];
  };
}
