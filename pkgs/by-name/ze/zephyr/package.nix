{
  lib,
  appimageTools,
  fetchurl,
}:
appimageTools.wrapType2 rec {
  pname = "zephyr";
  version = "2.4.3";

  src = fetchurl {
    url = "https://github.com/Juwan-Hwang/Zephyr/releases/download/v${version}/Zephyr_${version}_amd64-full.AppImage";
    hash = "sha256-b0x/47aPkdcJJZ2+lxVKw2L0WU1RkFRcPzeY13QHJJ0=";
  };

  extraInstallCommands =
    let
      appimageContents = appimageTools.extract { inherit pname version src; };
    in
    ''
      install -Dm444 ${appimageContents}/Zephyr.desktop -t $out/share/applications
      substituteInPlace $out/share/applications/Zephyr.desktop \
        --replace-fail 'Exec=Zephyr' 'Exec=zephyr'
      cp -r ${appimageContents}/usr/share/icons $out/share
    '';

  meta = {
    description = "Modern, lightweight Mihomo GUI client built with Rust and Tauri v2";
    homepage = "https://github.com/Juwan-Hwang/Zephyr";
    license = lib.licenses.mit;
    mainProgram = "zephyr";
    maintainers = [ ];
    platforms = [ "x86_64-linux" ];
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
  };
}
