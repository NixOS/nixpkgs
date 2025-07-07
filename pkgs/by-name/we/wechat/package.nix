{
  callPackage,
  fetchurl,
  lib,
  stdenvNoCC,
}:

let
  inherit (stdenvNoCC.hostPlatform) system;

  pname = "wechat";
  meta = {
    description = "Messaging and calling app";
    homepage = "https://www.wechat.com/en/";
    downloadPage = "https://linux.weixin.qq.com/en";
    license = lib.licenses.unfree;
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
    maintainers = with lib.maintainers; [ prince213 ];
    mainProgram = "wechat";
    platforms = [
      "aarch64-darwin"
      "x86_64-darwin"
      "aarch64-linux"
      "x86_64-linux"
    ];
  };

  sources =
    let
      # https://dldir1.qq.com/weixin/mac/mac-release.xml
      any-darwin = {
        version = "4.0.6.17-29381";
        src = fetchurl {
          url = "https://dldir1v6.qq.com/weixin/Universal/Mac/xWeChatMac_universal_4.0.6.17_29381.dmg";
          hash = "sha256-Fv5UYZ5+WfHvs+V3yiLSQitj++3WU+0GJsnIdlwB+TE=";
        };
      };
    in
    {
      aarch64-darwin = any-darwin;
      x86_64-darwin = any-darwin;
      aarch64-linux = {
        version = "4.0.1.11";
        src = fetchurl {
          url = "https://web.archive.org/web/20250512112413if_/https://dldir1v6.qq.com/weixin/Universal/Linux/WeChatLinux_arm64.AppImage";
          hash = "sha256-Rg+FWNgOPC02ILUskQqQmlz1qNb9AMdvLcRWv7NQhGk=";
        };
      };
      x86_64-linux = {
        version = "4.0.1.11";
        src = fetchurl {
          url = "https://web.archive.org/web/20250512110825if_/https://dldir1v6.qq.com/weixin/Universal/Linux/WeChatLinux_x86_64.AppImage";
          hash = "sha256-gBWcNQ1o1AZfNsmu1Vi1Kilqv3YbR+wqOod4XYAeVKo=";
        };
      };
    };
in
callPackage (if stdenvNoCC.hostPlatform.isDarwin then ./darwin.nix else ./linux.nix) {
  inherit pname meta;
  inherit (sources.${system} or (throw "Unsupported system: ${system}")) version src;
}
