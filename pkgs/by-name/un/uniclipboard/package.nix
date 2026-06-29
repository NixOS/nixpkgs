{
  lib,
  appimageTools,
  fetchurl,
  makeWrapper,
}:

let
  pname = "uniclipboard";
  version = "0.16.0";

  src = fetchurl {
    url = "https://github.com/UniClipboard/UniClipboard/releases/download/v${version}/UniClipboard_${version}_amd64.AppImage";
    hash = "sha256-QGWxY93KtEkTkIYS+xawDTc79DEM3VKBly2pHu2lpOo=";
  };

  appimageContents = appimageTools.extractType2 {
    inherit pname version src;
  };
in
appimageTools.wrapType2 {
  inherit pname version src;

  nativeBuildInputs = [ makeWrapper ];

  extraInstallCommands = ''
    wrapProgram $out/bin/uniclipboard \
      --add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--ozone-platform-hint=auto --enable-features=WaylandWindowDecorations --enable-wayland-ime=true}}"

    install -Dm444 ${appimageContents}/usr/share/applications/UniClipboard.desktop \
      $out/share/applications/uniclipboard.desktop
    substituteInPlace $out/share/applications/uniclipboard.desktop \
      --replace-fail 'Comment=一个剪切板同步工具' 'Comment=Encrypted peer-to-peer clipboard sync'
    cp -r ${appimageContents}/usr/share/icons $out/share/icons
  '';

  extraPkgs = pkgs: with pkgs; [ ];

  meta = {
    description = "Encrypted peer-to-peer clipboard sync between your devices";
    longDescription = ''
      UniClipboard syncs your clipboard securely across your devices on the local
      network. End-to-end encrypted and powered by iroh QUIC, with direct
      peer-to-peer sync of text, images, and files.
    '';
    homepage = "https://uniclipboard.app";
    downloadPage = "https://github.com/UniClipboard/UniClipboard/releases";
    license = lib.licenses.agpl3Only;
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    maintainers = with lib.maintainers; [ mkdir700 ];
    mainProgram = "uniclipboard";
    platforms = [ "x86_64-linux" ];
  };
}
