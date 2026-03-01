{
  callPackage,
  fetchurl,
  fetchzip,
  lib,
  stdenvNoCC,
}:

let
  inherit (stdenvNoCC.hostPlatform) system;
  sources = import ./sources.nix { inherit fetchurl fetchzip; };

  pname = "tuple";

  passthru = {
    updateScript = ./update.sh;
  };

  meta = {
    description = "Remote pair programming app";
    homepage = "https://tuple.app";
    changelog = "https://tuple.app/changelog";
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    license = lib.licenses.unfree;
    maintainers = [ lib.maintainers.maxbrunet ];
    platforms = [
      "aarch64-darwin"
      "aarch64-linux"
      "x86_64-darwin"
      "x86_64-linux"
    ];
    mainProgram = "tuple";
  };
in
callPackage (if stdenvNoCC.hostPlatform.isDarwin then ./darwin.nix else ./linux.nix) {
  inherit pname passthru meta;
  inherit (sources.${system} or (throw "Unsupported system: ${system}")) version src;
}
