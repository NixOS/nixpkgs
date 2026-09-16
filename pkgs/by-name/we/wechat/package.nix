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
    maintainers = with lib.maintainers; [
      larry0x
      prince213
    ];
    mainProgram = "wechat";
    platforms = [
      "aarch64-darwin"
      "aarch64-linux"
      "x86_64-linux"
    ];
  };

  sources = {
    # https://dldir1.qq.com/weixin/mac/mac-release.xml
    aarch64-darwin =
      let
        version = "4.1.13.59-269627";
        version' = lib.replaceString "-" "_" version;
      in
      {
        inherit version;
        src = fetchurl {
          url = "https://dldir1v6.qq.com/weixin/Universal/Mac/xWeChatMac_universal_${version'}.dmg";
          hash = "sha256-45zrtADGKikIfN+BQRMR74Pnmr4VHfXShamWEnOTdOk=";
        };
      };

    # the wechat official website does not provide downloads for previous versions
    # https://github.com/Rodert/wechat-linux-versions this project automatically fetches wechat downloads
    # and archive them with github releases
    aarch64-linux = {
      version = "4.1.1.8";
      src = fetchurl {
        url = "https://github.com/Rodert/wechat-linux-versions/releases/download/v4.1.1.8/WeChatLinux_arm64.AppImage";
        hash = "sha256-RLHhac3wSS1C9rx3GsA07Tp1EzxSf2LLBMyPtrECnUY=";
      };
    };
    x86_64-linux = {
      version = "4.1.1.8";
      src = fetchurl {
        url = "https://github.com/Rodert/wechat-linux-versions/releases/download/v4.1.1.8/WeChatLinux_x86_64.AppImage";
        hash = "sha256-RX26ArkbAxzdRBLu4HT7v/udnQax5Q/Bgi00hw4RSZA=";
      };
    };
  };
in
callPackage (if stdenvNoCC.hostPlatform.isDarwin then ./darwin.nix else ./linux.nix) {
  inherit pname meta;
  inherit (sources.${system} or (throw "Unsupported system: ${system}")) version src;
}
