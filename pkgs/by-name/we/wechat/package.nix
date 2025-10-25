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
          version = "4.1.0.34-29721";
          version' = lib.replaceString "-" "_" version;
        in
        {
          inherit version;
          src = fetchurl {
            url = "https://dldir1v6.qq.com/weixin/Universal/Mac/xWeChatMac_universal_${version'}.dmg";
            hash = "sha256-UwQrU4uVCKnAYXFSnlIfXQbBxyR3KNn6f1Mp4bCSAZI=";
          };
        };
    in
    {
      aarch64-darwin = any-darwin;
      x86_64-darwin = any-darwin;
      aarch64-linux = {
        version = "4.1.0.10";
        src = fetchurl {
          url = "https://web.archive.org/web/20250930121708/https://dldir1v6.qq.com/weixin/Universal/Linux/WeChatLinux_arm64.AppImage";
          hash = "sha256-qkNLA8nILsIi2ciIzr9pb3PejhbEvZ5fe4GlmjyjrEI=";
        };
      };
      x86_64-linux = {
        version = "4.1.0.10";
        src = fetchurl {
          url = "https://web.archive.org/web/20250930121506/https://dldir1v6.qq.com/weixin/Universal/Linux/WeChatLinux_x86_64.AppImage";
          hash = "sha256-d/zdb69gmIcgAFCbWLKGfmD8ZFfuDlYdOy7vUJ7SiXc=";
        };
      };
    };
in
callPackage (if stdenvNoCC.hostPlatform.isDarwin then ./darwin.nix else ./linux.nix) {
  inherit pname meta;
  inherit (sources.${system} or (throw "Unsupported system: ${system}")) version src;
}
