{
  callPackage,
  enableJavaFX ? false,
  ...
}@args:

let
  # For 24 JDK FX is newer than regular JDK?
  zuluVersion = if enableJavaFX then "24.28.85" else "24.28.83";
in
callPackage ./common.nix (
  {
    # Details from https://www.azul.com/downloads/?version=java-24&package=jdk
    # Note that the latest build may differ by platform
    dists = {
      x86_64-linux = {
        inherit zuluVersion;
        jdkVersion = "24.0.0";
        hash =
          if enableJavaFX then
            "sha256-y8jiE5yECh96pHYZFM0Q/JTiVcm5a0PONYJDLYydCT0="
          else
            "sha256-Kf6gF8A8ZFIhujEgjlENeuSPVzW6QWnVZcRst35/ZvI=";
      };

      aarch64-linux = {
        inherit zuluVersion;
        jdkVersion = "24.0.0";
        hash =
          if enableJavaFX then
            "sha256-H6YD8uhk9rTpd+3/S1+7QVzpCi6jykWKyu7RPxMx/sI="
          else
            "sha256-6J7szd/ax9xCMNA9efw9Bhgv/VwQFXz5glWIoj+UYIc=";
      };

      x86_64-darwin = {
        inherit zuluVersion;
        jdkVersion = "24.0.0";
        hash =
          if enableJavaFX then
            "sha256-lMdbPkUdXyNcye8uMxGIhZTErrTI0P0SnqMS+8+Rjqg="
          else
            "sha256-e7KJtJ9+mFFSdKCj68thfTXguWH5zXaSSb9phzXf/lQ=";
      };

      aarch64-darwin = {
        inherit zuluVersion;
        jdkVersion = "24.0.0";
        hash =
          if enableJavaFX then
            "sha256-oR2x0vphBGgh3KkEkLAcmtIMNONny9/b32z9jLR98X0="
          else
            "sha256-7yXLOJCK0RZ8V1vsexOGxGR9NAwi/pCl95BlO8E8nGU=";
      };
    };
  }
  // builtins.removeAttrs args [ "callPackage" ]
)
