{ callPackage
, enableJavaFX ? false
, ...
}@args:

callPackage ./common.nix ({
  # Details from https://www.azul.com/downloads/?version=java-19-sts&os=macos&package=jdk
  # Note that the latest build may differ by platform
  dists = {
    x86_64-darwin = {
      arch = "x64";
      zuluVersion = if enableJavaFX then "19.32.15" else "19.32.13";
      jdkVersion = "19.0.2";
      hash =
        if enableJavaFX then "sha256-AwLcIId0gH5D6DUU8CgJ3qnKVQm28LXYirBeXBHwPYE="
        else "sha256-KARXWumsY+OcqpEOV2EL9SsPni1nGSipjRji/Mn2KsE=";
    };

    aarch64-darwin = {
      arch = "aarch64";
      zuluVersion = if enableJavaFX then "19.32.15" else "19.32.13";
      jdkVersion = "19.0.2";
      hash =
        if enableJavaFX then "sha256-/R2rrcBr64qPGEtvhruXBhPwnvurt/hiR1ICzZAdYxE="
        else "sha256-F30FjZaLL756X/Xs6xjNwW9jds4pEATxoxOeeLL7Y5E=";
    };
  };
} // builtins.removeAttrs args [ "callPackage" ])
