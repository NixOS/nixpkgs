{ callPackage
, enableJavaFX ? false
, stdenv
, ...
}@args:

callPackage ./common.nix ({
  # Details from https://www.azul.com/downloads/?version=java-18-sts&os=macos&package=jdk
  # Note that the latest build may differ by platform
  dist = {
    x86_64-darwin = {
      arch = "x64";
      zuluVersion = "18.32.13";
      jdkVersion = "18.0.2.1";
      hash =
        if enableJavaFX then "sha256-ZVZ1gbpJwxTduq2PPOCKqbSl+shq2NTFgqG++OXvFcg="
        else "sha256-uHPcyOgxUdTgzmIVRp/awtwve9zSt+1TZNef7DUuoRg=";
    };

    aarch64-darwin = {
      arch = "aarch64";
      zuluVersion = "18.32.13";
      jdkVersion = "18.0.2.1";
      hash =
        if enableJavaFX then "sha256-tNx0a1u9iamcN9VFOJ3eqDEA6C204dtIBJZvuAH2Vjk="
        else "sha256-jAZDgxtWMq/74yKAxA69oOU0C9nXvKG5MjmZLsK04iM=";
    };
  }."${stdenv.hostPlatform.system}";
} // builtins.removeAttrs args [ "callPackage" ])
