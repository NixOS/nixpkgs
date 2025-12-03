lib: {
  description = "Widevine CDM";
  homepage = "https://www.widevine.com";
  sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
  license = lib.licenses.unfree;
  maintainers = with lib.maintainers; [
    jlamur
    bearfm
  ];
  platforms = lib.map (lib.removeSuffix ".nix") (
    lib.filter (name: name != "meta.nix" && name != "package.nix") (
      builtins.attrNames (builtins.readDir ./.)
    )
  );
}
