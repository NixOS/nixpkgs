{
  callPackage,
  enableJavaFX ? false,
  ...
}@args:

let
  zuluVersion = "26.32.13";
  jdkVersion = "26.0.2";
in
callPackage ./common.nix (
  {
    # Details from https://www.azul.com/downloads/?version=java-26&package=jdk
    # Note that the latest build may differ by platform
    dists = {
      x86_64-linux = {
        inherit zuluVersion jdkVersion;
        hash =
          if enableJavaFX then
            "sha256-Fhp5IZQVxbMeuJkA9ou1IcLknV+RSchvKSZ0qvknEAg="
          else
            "sha256-S3wRSReuvQ/GKE/HERJF13R6TZYDvRLYazhLGrydV10=";
      };

      aarch64-linux = {
        inherit zuluVersion jdkVersion;
        hash =
          if enableJavaFX then
            "sha256-2R2xJ1s2phCOqE4riZP2PmvSLrnI4Vh6pOHXCJYQX8k="
          else
            "sha256-WyIvzgtwdqEKx647EAmmwsr081vE6B3nIBCvZ1DF4UY=";
      };

      aarch64-darwin = {
        inherit zuluVersion jdkVersion;
        hash =
          if enableJavaFX then
            "sha256-CpWtHU/wMi/qicTQSSvSFIUBvn6+dgsTiXjJynaPjXE="
          else
            "sha256-TplY/EWdjdcvxRshMUsgtngTL8VCkV2fqojRCkoTe6I=";
      };
    };
  }
  // removeAttrs args [ "callPackage" ]
)
