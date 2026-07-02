{
  callPackage,
  enableJavaFX ? false,
  ...
}@args:

let
  # JDK FX can potentially be different version than regular JDK
  zuluVersion = if enableJavaFX then "21.50.19" else "21.50.19";
  jdkVersion = "21.0.11";
in
callPackage ./common.nix (
  {
    # Details from https://www.azul.com/downloads/?version=java-21-lts&package=jdk
    # Note that the latest build may differ by platform
    dists = {
      x86_64-linux = {
        inherit zuluVersion jdkVersion;
        hash =
          if enableJavaFX then
            "sha256-YG9T25gv8n+LQ5yHPCNnpcv5D5/YVXj6jrB8AWqzbY4="
          else
            "sha256-vF4zg0Mct/Hc6MJi3UdFAe6b11afHFmotv5cFYmqSlg=";
      };

      aarch64-linux = {
        inherit zuluVersion jdkVersion;
        hash =
          if enableJavaFX then
            "sha256-yIcj1OeL2mGJwF0SYGYnuc03OvhpIupo/BC8qINnIUs="
          else
            "sha256-zUvl6u1Q0rgUhd/iYOL6t+LJCoVL8Rt7+07raTZ1fEo=";
      };

      x86_64-darwin = {
        inherit zuluVersion jdkVersion;
        hash =
          if enableJavaFX then
            "sha256-5/L0FqpL6488uwzimXh9G6Io2cCTnU1+8n/6E+CNDK8="
          else
            "sha256-kGmQy+WZcx48jshfem8uctSg+ewcwYtrUqFuHi/Fk00=";
      };

      aarch64-darwin = {
        inherit zuluVersion jdkVersion;
        hash =
          if enableJavaFX then
            "sha256-XEKUQWG187kByQOTpQrD4aCFCo+MyeuGGY2UqDRq/WQ="
          else
            "sha256-Wc+JaVGh880TKr/B90uk2x+RbsyBs8ACLFwWohrpQK0=";
      };
    };
  }
  // removeAttrs args [ "callPackage" ]
)
