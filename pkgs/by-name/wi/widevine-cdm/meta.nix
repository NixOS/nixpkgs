lib: {
  description = "Widevine CDM";
  homepage = "https://www.widevine.com";
  sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
  license = lib.licenses.unfree;
  maintainers = with lib.maintainers; [
    jlamur
    bearfm
  ];
<<<<<<< HEAD
  platforms = [
    "x86_64-linux"
    "aarch64-linux"
  ];
=======
  platforms = lib.map (lib.removeSuffix ".nix") (
    lib.filter (name: name != "meta.nix" && name != "package.nix") (
      builtins.attrNames (builtins.readDir ./.)
    )
  );
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
}
