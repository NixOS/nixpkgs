{ callPackage
, enableJavaFX ? false
, stdenv
, ...
}@args:

callPackage ./common.nix ({
  # Details from https://www.azul.com/downloads/?version=java-19-sts&os=macos&package=jdk
  # Note that the latest build may differ by platform
  dist = {
    x86_64-darwin = {
      arch = "x64";
      zuluVersion = "20.32.11";
      jdkVersion = "20.0.2";
      hash =
        if enableJavaFX then "sha256-hyxQAivZAXtqMebe30L+EYa7p+TdSdKNYj7Rl/ZwRNQ="
        else "sha256-Ev9KG6DvuBnsZrOguLsO1KQzudHCBcJNwKh45Inpnfo=";
    };

    aarch64-darwin = {
      arch = "aarch64";
      zuluVersion = "20.32.11";
      jdkVersion = "20.0.2";
      hash =
        if enableJavaFX then "sha256-iPQzZS4CwaoqT8cSzg4kWCT1OyGBSJLq+NETcbucLo4="
        else "sha256-15uNZ6uMfSASV3QU2q2oA/jBk2PCHOfSjn1GY7/7qIY=";
    };
  }."${stdenv.hostPlatform.system}";
} // builtins.removeAttrs args [ "callPackage" ])
