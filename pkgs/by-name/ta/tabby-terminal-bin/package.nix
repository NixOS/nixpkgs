{
  lib,
  stdenv,
  appimageTools,
  fetchurl,
  asar,
}:
let
  pname = "tabby-terminal-bin";
  version = "1.0.223";

  src =
    {
      x86_64-linux = fetchurl {
        url = "https://github.com/Eugeny/tabby/releases/download/v${version}/tabby-${version}-linux-x64.AppImage";
        hash = "sha256-qHHodFgRt+t1ACq9aSgn15PkZihpD084VP0A4YqZ95o=";
      };
      aarch64-linux = fetchurl {
        url = "https://github.com/Eugeny/tabby/releases/download/v${version}/tabby-${version}-linux-arm64.AppImage";
        hash = "sha256-fO8E9BKKV4GJFRuJX0Lza/8wGm46EIwd8F2ZGABoaqg=";
      };
    }
    .${stdenv.hostPlatform.system}
      or (throw "${pname}-${version}: ${stdenv.hostPlatform.system} is unsupported.");

  appimageContents = appimageTools.extract {
    inherit pname version src;
    postExtract = ''
      # Get rid of the autoupdater
      ${asar}/bin/asar extract $out/resources/app.asar app
      sed -i 's/async isUpdateAvailable.*/async isUpdateAvailable(updateInfo) { return false;/g' app/node_modules/electron-updater/out/AppUpdater.js
      ${asar}/bin/asar pack app $out/resources/app.asar
    '';
  };

in
appimageTools.wrapAppImage {
  inherit pname version;
  src = appimageContents;

  extraPkgs = pkgs: [ pkgs.hidapi ];

  extraInstallCommands = ''
    # Add desktop convencience stuff
    install -Dm444 ${appimageContents}/tabby.desktop -t $out/share/applications
    install -Dm444 ${appimageContents}/tabby.png -t $out/share/pixmaps
    mv $out/bin/${pname} $out/bin/tabby
    substituteInPlace $out/share/applications/tabby.desktop \
      --replace-fail 'Exec=AppRun' 'Exec=tabby'
  '';

  meta = {
    homepage = "https://tabby.sh";
    description = "Terminal for the modern age";
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
    ];
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      pokon548
    ];
    # https://www.electronjs.org/docs/latest/tutorial/electron-timelines
    knownVulnerabilities = [ "Electron version 32 is EOL" ];
    mainProgram = "tabby";
  };
}
