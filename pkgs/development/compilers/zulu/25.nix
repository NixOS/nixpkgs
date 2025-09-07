{
  callPackage,
  enableJavaFX ? false,
  ...
}@args:

let
  # For Zulu 25-EA, FX and non-FX versions can differ (but are currently the same)
  zuluVersion = if enableJavaFX then "25.0.47" else "25.0.47";
in
callPackage ./common.nix (
  {
    # Details from https://www.azul.com/downloads/?version=java-24&package=jdk
    # Note that the latest build may differ by platform
    dists = {
      x86_64-linux = {
        inherit zuluVersion;
        jdkVersion = "25.0.0-beta.34";
        hash =
          if enableJavaFX then
            throw "JavaFX not currently available in 25(EA)"
          else
            "sha256-sRwmddaZfT/L7y1CBwiuTx3cl/9CRsEqOKTJ+NA1rR4=";
      };

      aarch64-linux = {
        inherit zuluVersion;
        jdkVersion = "25.0.0-beta.34";
        hash =
          if enableJavaFX then
            throw "JavaFX not currently available in 25(EA)"
          else
            "sha256-qPZd3Kmt/bEqauSWhP56c35kdDRapMclYQ5G0G6qe7k=";
      };

      x86_64-darwin = {
        inherit zuluVersion;
        jdkVersion = "25.0.0-beta.34";
        hash =
          if enableJavaFX then
            throw "JavaFX not currently available in 25(EA)"
          else
            "sha256-6gZ1BEzMe96qIlGvRBgQVRJsrr1txXciwLk952PRYEs=";
      };

      aarch64-darwin = {
        inherit zuluVersion;
        jdkVersion = "25.0.0-beta.34";
        hash =
          if enableJavaFX then
            throw "JavaFX not currently available in 25(EA)"
          else
            "sha256-7XjZfOsa50dPHFEXu4Dfr2r6M1YaCU3ffNR3NscpEnk=";
      };
    };
  }
  // builtins.removeAttrs args [ "callPackage" ]
)
