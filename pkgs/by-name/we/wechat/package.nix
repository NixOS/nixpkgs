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
      any-darwin =
        let
          version = "4.1.7.31-34366";
          version' = lib.replaceString "-" "_" version;
        in
        {
          inherit version;
          src = fetchurl {
            url = "https://dldir1v6.qq.com/weixin/Universal/Mac/xWeChatMac_universal_${version'}.dmg";
            hash = "sha256-oU1qypU24wiHSdUo8H76A1hxKCDf3I3Fq/4xbNGbjDo=";
          };
        };
    in
    {
      aarch64-darwin = any-darwin;
      x86_64-darwin = any-darwin;
      # use https://web.archive.org/save to archive the Linux versions
      # add `if_` at the end of timestamps to avoid toolbar insertion
      # for a more complicated guide, see https://en.wikipedia.org/wiki/Help:Using_the_Wayback_Machine
      aarch64-linux = {
        version = "4.1.1.4";
        src = fetchurl {
          url = "https://web.archive.org/web/20260311102559if_/https://dldir1v6.qq.com/weixin/Universal/Linux/WeChatLinux_arm64.AppImage";
          hash = "sha256-YlWJxT62tXDaNwYVpsPMC5elFH8fsbI1HjTQn6ePiPo=";
        };
      };
      x86_64-linux = {
        version = "4.1.1.4";
        src = fetchurl {
          url = "https://web.archive.org/web/20260311102439if_/https://dldir1v6.qq.com/weixin/Universal/Linux/WeChatLinux_x86_64.AppImage";
          hash = "sha256-XxAvFnlljqurGPDgRr+DnuCKbdVvgXBPh02DLHY3Oz8=";
        };
      };
    };
in
callPackage (if stdenvNoCC.hostPlatform.isDarwin then ./darwin.nix else ./linux.nix) {
  inherit pname meta;
  inherit (sources.${system} or (throw "Unsupported system: ${system}")) version src;
}
