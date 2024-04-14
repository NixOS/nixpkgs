{ callPackage
, enableJavaFX ? false
, ...
}@args:

callPackage ./common.nix ({
  # Details from https://www.azul.com/downloads/?version=java-20-sts&package=jdk
  # Note that the latest build may differ by platform
  dists = {
    x86_64-darwin = {
      zuluVersion = "20.32.11";
      jdkVersion = "20.0.2";
      hash =
        if enableJavaFX then "sha256-hyxQAivZAXtqMebe30L+EYa7p+TdSdKNYj7Rl/ZwRNQ="
        else "sha256-Ev9KG6DvuBnsZrOguLsO1KQzudHCBcJNwKh45Inpnfo=";
    };

    aarch64-darwin = {
      zuluVersion = "20.32.11";
      jdkVersion = "20.0.2";
      hash =
        if enableJavaFX then "sha256-iPQzZS4CwaoqT8cSzg4kWCT1OyGBSJLq+NETcbucLo4="
        else "sha256-15uNZ6uMfSASV3QU2q2oA/jBk2PCHOfSjn1GY7/7qIY=";
    };
  };
} // builtins.removeAttrs args [ "callPackage" ])
