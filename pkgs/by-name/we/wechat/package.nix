{
  lib,
  appimageTools,
  fetchurl,
  stdenvNoCC,
}:

let
  inherit (stdenvNoCC.hostPlatform) system;
  pname = "wechat";
  version = "4.0.1.11";
  sources = {
    aarch64-linux = fetchurl {
      url = "https://web.archive.org/web/20250512112413if_/https://dldir1v6.qq.com/weixin/Universal/Linux/WeChatLinux_arm64.AppImage";
      hash = "sha256-Rg+FWNgOPC02ILUskQqQmlz1qNb9AMdvLcRWv7NQhGk=";
    };
    x86_64-linux = fetchurl {
      url = "https://web.archive.org/web/20250512110825if_/https://dldir1v6.qq.com/weixin/Universal/Linux/WeChatLinux_x86_64.AppImage";
      hash = "sha256-gBWcNQ1o1AZfNsmu1Vi1Kilqv3YbR+wqOod4XYAeVKo=";
    };
  };
  src = appimageTools.extract {
    inherit pname version;
    src = sources.${system};
    postExtract = ''
      patchelf --replace-needed libtiff.so.5 libtiff.so $out/opt/wechat/wechat
    '';
  };
in

appimageTools.wrapAppImage {
  inherit pname version src;

  extraInstallCommands = ''
    mkdir -p $out/share/applications
    cp ${src}/wechat.desktop $out/share/applications/
    mkdir -p $out/share/pixmaps
    cp ${src}/wechat.png $out/share/pixmaps/

    substituteInPlace $out/share/applications/wechat.desktop --replace-fail AppRun wechat
  '';

  meta = {
    description = "Messaging and calling app";
    homepage = "https://www.wechat.com/en/";
    downloadPage = "https://linux.weixin.qq.com/en";
    license = lib.licenses.unfree;
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
    maintainers = with lib.maintainers; [ prince213 ];
    mainProgram = "wechat";
    platforms = [
      "aarch64-linux"
      "x86_64-linux"
    ];
  };
}
