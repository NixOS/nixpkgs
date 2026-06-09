{
  callPackage,
  enableJavaFX ? false,
  ...
}@args:
let
  zuluVersion = "17.66.19";
  jdkVersion = "17.0.19";
in
callPackage ./common.nix (
  {
    # Details from https://www.azul.com/downloads/?version=java-17-lts&package=jdk
    # Note that the latest build may differ by platform
    dists = {
      x86_64-linux = {
        inherit zuluVersion jdkVersion;
        hash =
          if enableJavaFX then
            "sha256-FCp5FoevH8ekD+AZhapvcqc8EpD08ubJ+UFCzwzDWJQ="
          else
            "sha256-rTGaq+ZZwY+mP620RgJqfH9SYPAqYVn1EZVzXSDnqhw=";
      };

      aarch64-linux = {
        inherit zuluVersion jdkVersion;
        hash =
          if enableJavaFX then
            "sha256-NzY55vSha3gxmPS9dQK2827q8eAfkcfPXoiZ6KODpfQ="
          else
            "sha256-wX1WV6ZzwM/AmenYA+0wSYSViU1zWf0QZNRjCT7ZhQs=";
      };

      x86_64-darwin = {
        inherit zuluVersion jdkVersion;
        hash =
          if enableJavaFX then
            "sha256-3DHXEjYN9RXYD4sB/75/fATzPAwJmZv3D+PaSU8qrog="
          else
            "sha256-anuLI/JBnqHd5+6s4NWkzF2+e7yDqN2jXcZKoSJp0EE=";
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
