{
  callPackage,
  fetchurl,
  lib,
  stdenvNoCC,
}:

let
  inherit (stdenvNoCC.hostPlatform) system;

  sources = lib.importJSON ./sources.json;
  source = sources.${system} or (throw "Unsupported system: ${system}");

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
    platforms = lib.attrNames sources;
  };
in
callPackage (if stdenvNoCC.hostPlatform.isDarwin then ./darwin.nix else ./linux.nix) {
  inherit pname meta;
  inherit (source) version;
  src = fetchurl source.src;
  passthru = {
    updateScript = ./update.py;
  };
}
