{
  sources ? ./sources.nix,

  lib,
  stdenvNoCC,
  fetchurl,
  callPackage,
}:

let
  inherit (stdenvNoCC.hostPlatform) system;

  pname = "zotero";
  sources = import ./sources.nix { inherit fetchurl; };
  meta = {
    homepage = "https://www.zotero.org";
    description = "Collect, organize, cite, and share your research sources";
    mainProgram = "zotero";
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
    license = lib.licenses.agpl3Only;
    platforms = [
      "aarch64-darwin"
      "aarch64-linux"
      "x86_64-darwin"
      "x86_64-linux"
    ];
    maintainers = with lib.maintainers; [
      atila
      justanotherariel
    ];
  };
in
callPackage (if stdenvNoCC.hostPlatform.isDarwin then ./darwin.nix else ./linux.nix) {
  inherit pname meta;
  inherit (sources.${system} or (throw "Unsupported system: ${system}")) version src;
}
