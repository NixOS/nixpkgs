{
  lib,
  appimageTools,
  fetchurl,
  writeShellScript,
  curl,
  yq,
  common-updater-scripts,
}:

appimageTools.wrapType2 (finalAttrs: {
  pname = "tastytrade";
  version = "0.60.0";

  src = fetchurl {
    url = "https://download.tastytrade.com/desktop-2.0/tastytrade-linux-x86_64-${finalAttrs.version}.AppImage";
    hash = "sha512-xhoavRXrvBCatz7922MRIa6FdIev6vQqvsZg4SGDsbUd5lfLCtOQs8zn2iPInlu/nkvlFpM+g13fwyXWyOJqYw==";
  };

  strictDeps = true;
  __structuredAttrs = true;

  # Electron dlopens libnotify for desktop notifications
  extraPkgs = pkgs: [ pkgs.libnotify ];

  extraInstallCommands = ''
    install -Dm444 ${finalAttrs.contents}/tastytrade.desktop -t $out/share/applications
    install -Dm444 ${finalAttrs.contents}/usr/share/icons/hicolor/512x512/apps/tastytrade.png \
      -t $out/share/icons/hicolor/512x512/apps
    substituteInPlace $out/share/applications/tastytrade.desktop \
      --replace-fail 'Exec=AppRun --no-sandbox %U' 'Exec=tastytrade %U'
  '';

  passthru.updateScript = writeShellScript "update-tastytrade" ''
    set -euo pipefail
    yml=$(${lib.getExe curl} -fsS https://download.tastytrade.com/desktop-2.0/latest-linux.yml)
    version=$(${lib.getExe yq} -r .version <<<"$yml")
    hash=$(${lib.getExe yq} -r .sha512 <<<"$yml")
    ${lib.getExe' common-updater-scripts "update-source-version"} tastytrade "$version" "sha512-$hash"
  '';

  meta = {
    description = "Desktop trading platform for stocks, options and futures";
    homepage = "https://tastytrade.com";
    license = lib.licenses.unfree;
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    maintainers = with lib.maintainers; [ divyacote ];
    platforms = [ "x86_64-linux" ];
    mainProgram = "tastytrade";
  };
})
