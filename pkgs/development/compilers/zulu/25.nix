{
  callPackage,
  enableJavaFX ? false,
  ...
}@args:

let
  # For 25-EA JDK, FX and non-FX versions are the same (currently)
  zuluVersion = if enableJavaFX then "25.0.41" else "25.0.41";
in
callPackage ./common.nix (
  {
    # Details from https://www.azul.com/downloads/?version=java-24&package=jdk
    # Note that the latest build may differ by platform
    dists = {
      x86_64-linux = {
        inherit zuluVersion;
        jdkVersion = "25.0.0";
        hash =
          if enableJavaFX then
            throw "JavaFX not currently available in 25(EA)"
          else
            "sha256-XdcsBu96mgGBepo5XpO6Lu94w50D4mzS2QUH0qL/nvc=";
      };

      aarch64-linux = {
        inherit zuluVersion;
        jdkVersion = "25.0.0";
        hash =
          if enableJavaFX then
            throw "JavaFX not currently available in 25(EA)"
          else
            "sha256-V+84pcT6KSNb+Yg5qx2Hy11ftI7Mkus4lhcbcAmOfOU=";
      };

      x86_64-darwin = {
        inherit zuluVersion;
        jdkVersion = "25.0.0";
        hash =
          if enableJavaFX then
            throw "JavaFX not currently available in 25(EA)"
          else
            "sha256-NBoj2ET56ZfPkX2xnKDcw40zyGc+yTt0/Gk+vIi3Y5Y=";
      };

      aarch64-darwin = {
        inherit zuluVersion;
        jdkVersion = "25.0.0";
        hash =
          if enableJavaFX then
            throw "JavaFX not currently available in 25(EA)"
          else
            throw "aarch64-darwin not currently available in 25(EA)";
      };
    };
  }
  // builtins.removeAttrs args [ "callPackage" ]
)
