{
  callPackage,
  enableJavaFX ? false,
  ...
}@args:
let
  zuluVersion = "17.66.19";
  jdkVersion = "17.0.19";
  # The November security update is available for the plain Linux JDK.
  linuxZuluVersion = if enableJavaFX then zuluVersion else "17.70.201";
  linuxJdkVersion = if enableJavaFX then jdkVersion else "17.0.21.1";
in
callPackage ./common.nix (
  {
    # Details from https://www.azul.com/downloads/?version=java-17-lts&package=jdk
    # Note that the latest build may differ by platform
    dists = {
      x86_64-linux = {
        zuluVersion = linuxZuluVersion;
        jdkVersion = linuxJdkVersion;
        hash =
          if enableJavaFX then
            "sha256-FCp5FoevH8ekD+AZhapvcqc8EpD08ubJ+UFCzwzDWJQ="
          else
            "sha256-KDeu50Jn4CEG7mAGgJuw3iPM+kO/UAViFRcZS3mXVpU=";
      };

      aarch64-linux = {
        zuluVersion = linuxZuluVersion;
        jdkVersion = linuxJdkVersion;
        hash =
          if enableJavaFX then
            "sha256-NzY55vSha3gxmPS9dQK2827q8eAfkcfPXoiZ6KODpfQ="
          else
            "sha256-v4pB+51Gnm1kXNZNm9RyajXUlv+CHoEsQgRub+d7RYc=";
      };

      aarch64-darwin = {
        inherit zuluVersion jdkVersion;
        hash =
          if enableJavaFX then
            "sha256-szuMbtvi8wbKnbtwRjKIUQgb9LReDk6jCooECnpn6nM="
          else
            "sha256-8r1a+qqkwj60vyx4kTx+t9PSKORCCf/sZS+3I4ii8lw=";
      };
    };
  }
  // removeAttrs args [ "callPackage" ]
)
