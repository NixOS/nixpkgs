{
  lib,
  appimageTools,
  fetchurl,
  asar,
}:
let
  pname = "todoist-electron";
  version = "9.8.0";

  src = fetchurl {
    url = "https://electron-dl.todoist.com/linux/Todoist-linux-${version}-x86_64-latest.AppImage";
    hash = "sha256-ZuoeeQ7SusRhr5BXBYEWCZ9pjdcWClKoR0mnom1XkPg=";
  };

  appimageContents = (appimageTools.extract { inherit pname version src; }).overrideAttrs (oA: {
    buildCommand = ''
      ${oA.buildCommand}

      # Get rid of the autoupdater
      ${asar}/bin/asar extract $out/resources/app.asar app
      sed -i 's/async isUpdateAvailable.*/async isUpdateAvailable(updateInfo) { return false;/g' app/node_modules/electron-updater/out/AppUpdater.js
      ${asar}/bin/asar pack app $out/resources/app.asar
    '';
  });

in
appimageTools.wrapAppImage {
  inherit pname version;
  src = appimageContents;

  extraPkgs = pkgs: [ pkgs.hidapi ];

  extraInstallCommands = ''
    # Add desktop convencience stuff
    install -Dm444 ${appimageContents}/todoist.desktop -t $out/share/applications
    install -Dm444 ${appimageContents}/todoist.png -t $out/share/pixmaps
    substituteInPlace $out/share/applications/todoist.desktop \
      --replace 'Exec=AppRun' "Exec=$out/bin/${pname} --"
  '';

  meta = with lib; {
    homepage = "https://todoist.com";
    description = "Official Todoist electron app";
    platforms = [ "x86_64-linux" ];
    license = licenses.unfree;
    maintainers = with maintainers; [
      kylesferrazza
      pokon548
    ];
    mainProgram = "todoist-electron";
  };
}
