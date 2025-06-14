{
  callPackage,
  fetchurl,
  fetchzip,
  lib,
  stdenvNoCC,
  undmg-hdiutil,
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
      any-darwin = {
        version = "4.0.5.24";
        src = fetchzip {
          url = "https://web.archive.org/web/20250608064358if_/https://dldir1v6.qq.com/weixin/Universal/Mac/WeChatMac.dmg";
          hash = "sha256-kjPOqlO9C00vmCRfX/N5V1xZkLHexiOJ8jq45v5gyTk=";
          nativeBuildInputs = [ undmg-hdiutil ];
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
  inherit (sources.${system}) version src;
}
