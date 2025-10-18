{
  channel ? "release",

  lib,
  stdenvNoCC,
  fetchurl,
  callPackage,
}:

let
  inherit (stdenvNoCC.hostPlatform) system;

  pname = "zotero";
  sources = import ./sources-${channel}.nix { inherit fetchurl; };
  passthru = {
    updateScript = [
      ./update.sh
      channel
    ];
  };
  meta = {
    homepage = "https://www.zotero.org";
    description = "Collect, organize, cite, and share your research sources";
    mainProgram = "zotero";
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
    license = lib.licenses.agpl3Only;
    platforms = [
      "aarch64-darwin"
      "x86_64-darwin"
      "x86_64-linux"
    ]
    ++ lib.optional (channel == "beta") "aarch64-linux";
    maintainers = with lib.maintainers; [
      atila
      justanotherariel
    ];
  };
in
callPackage (if stdenvNoCC.hostPlatform.isDarwin then ./darwin.nix else ./linux.nix) {
  inherit
    channel
    pname
    meta
    passthru
    ;
  inherit (sources.${system} or (throw "Unsupported system: ${system}")) version src;
}
