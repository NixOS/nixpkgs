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
    lib.filter (
      name:
      (lib.strings.hasPrefix "x86_64" name || lib.strings.hasPrefix "aarch64" name)
      && lib.strings.hasSuffix ".nix" name
    ) (builtins.attrNames (builtins.readDir ./.))
  );
}
