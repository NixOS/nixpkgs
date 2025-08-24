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
        jdkVersion = "25.0.0-beta.33";
        hash =
          if enableJavaFX then
            throw "JavaFX not currently available in 25(EA)"
          else
            "sha256-wF1rgyeXP6FTnsrGuGjAjUo0pyjazaKKsAmZsIgG+XE=";
      };

      aarch64-linux = {
        inherit zuluVersion;
        jdkVersion = "25.0.0-beta.33";
        hash =
          if enableJavaFX then
            throw "JavaFX not currently available in 25(EA)"
          else
            "sha256-h4E2JMBhi1CAoTlkhBE3SnMQn8zMFe1d9Dn2p+guhyM=";
      };

      x86_64-darwin = {
        inherit zuluVersion;
        jdkVersion = "25.0.0-beta.33";
        hash =
          if enableJavaFX then
            throw "JavaFX not currently available in 25(EA)"
          else
            "sha256-1mldYbs1mVHvKH8WaHAxGscJtDXMJ9lA3ijkAv7uznc=";
      };

      aarch64-darwin = {
        inherit zuluVersion;
        jdkVersion = "25.0.0-beta.33";
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
