{
  callPackage,
  enableJavaFX ? false,
  ...
}@args:
let
  zuluVersion = "8.94.0.17";
  jdkVersion = "8.0.492";
in
callPackage ./common.nix (
  {
    # Details from https://www.azul.com/downloads/?version=java-8-lts&package=jdk
    # Note that the latest build may differ by platform
    dists = {
      x86_64-linux = {
        inherit zuluVersion jdkVersion;
        hash =
          if enableJavaFX then
            "sha256-/2LCORNb2xXPuQZkNgsN7rjZU/FW9j8SmbOe26jvdeU="
          else
            "sha256-ptFBBPLnGGy6iUPE3BgpONuRUJ3CwO+ezuBGyGRiTTY=";
      };

      aarch64-linux = {
        inherit zuluVersion jdkVersion;
        hash =
          if enableJavaFX then
            "sha256-aoHwrAacHQA0yI7u3dBYu/oiRpYUQF1ZBwFErun6Wd8="
          else
            "sha256-JPXoGDpS77WrzuK4FzsIhwibp0dvEbwVYDRkNTzE5Kg=";
      };

      x86_64-darwin = {
        inherit zuluVersion jdkVersion;
        hash =
          if enableJavaFX then
            "sha256-5r2/yl4xHjLpaakRZ/khICGxUaoKk1GDvPJ56pliIwc="
          else
            "sha256-URSyabiOPYmw1rLCivDJa1SJ80D7re2PoXYTsq3KGAw=";
      };

      aarch64-darwin = {
        inherit zuluVersion jdkVersion;
        hash =
          if enableJavaFX then
            "sha256-RluOwTuXKtAa8pyYFf8fpj2ApgPzuuG/HmSppRdqbR0="
          else
            "sha256-c7hKv/DKShtki2zRI4EZRJa88x7gHyvdHtCRTJ7loVk=";
      };
    };
  }
  // removeAttrs args [ "callPackage" ]
)
