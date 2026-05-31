{
  callPackage,
  enableJavaFX ? false,
  ...
}@args:

let
  # FX and non-FX versions can differ
  zuluVersion = if enableJavaFX then "26.28.63" else "26.28.59";
in
callPackage ./common.nix (
  {
    # Details from https://www.azul.com/downloads/?version=java-26&package=jdk
    # Note that the latest build may differ by platform
    dists = {
      x86_64-linux = {
        inherit zuluVersion;
        jdkVersion = "26.0.0";
        hash =
          if enableJavaFX then
            "sha256-G9cMHwzNLF4B+ktHkbG0tCqf2PCpowfGf3ugySAPhzs="
          else
            "sha256-tjdGK5wWv7lV8CQKTN1WOPlSP7Nd4We8oYnThHXxk/0=";
      };

      aarch64-linux = {
        inherit zuluVersion;
        jdkVersion = "26.0.0";
        hash =
          if enableJavaFX then
            "sha256-p9PxZjLgcGgxuQcf8inWySseI3SbCr5JgK0mLBZ68NI="
          else
            "sha256-eX/at6DSefwfWedxD7AxzyC9DUvjZvHaFRAJ+ptdPKA=";
      };

      x86_64-darwin = {
        inherit zuluVersion;
        jdkVersion = "26.0.0";
        hash =
          if enableJavaFX then
            "sha256-WKv3CC8OgAmXaxremyAv0xegCVynyaCHrr+EvxbpLIc="
          else
            "sha256-Oo1SDGPurZ2nZRcpG15Y3rySO1rXpIplSAWhWm8IB/k=";
      };

      aarch64-darwin = {
        inherit zuluVersion;
        jdkVersion = "26.0.0";
        hash =
          if enableJavaFX then
            "sha256-GSI3mLyQ/ELtYLQdN0Yc7XQrn5bH9on88qY7sfRhTxk="
          else
            "sha256-99FRrcyRtqJROYMGawyh20Cd+Z16OoesMbIeYMl4pcc=";
      };
    };
  }
  // removeAttrs args [ "callPackage" ]
)
