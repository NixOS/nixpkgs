{
  callPackage,
  enableJavaFX ? false,
  ...
}@args:

callPackage ./common.nix (
  {
    # Details from https://www.azul.com/downloads/?version=java-21-lts&package=jdk
    # Note that the latest build may differ by platform
    dists = {
      x86_64-linux = {
        zuluVersion = "21.36.17";
        jdkVersion = "21.0.4";
        hash =
          if enableJavaFX then
            "sha256-Q2bdM0/a2t5aBRCIzXBlhXamf8N7wdSUsK5VhaU9DcY="
          else
            "sha256-MY0MLtPIdvt+oslSlFzc997PtSZMpRrs4VnmNaxT1UQ=";
      };

      aarch64-linux = {
        zuluVersion = "21.36.17";
        jdkVersion = "21.0.4";
        hash =
          if enableJavaFX then
            "sha256-BzNEcDrQo5yOWnEsJxw9JfXYdZGN6/wxnTDB0qC1i/0="
          else
            "sha256-2jwtfbM2cLz2ZTJEGut/M9zw0ifI2v5841zuZ/aCnEw=";
      };

      x86_64-darwin = {
        zuluVersion = "21.36.17";
        jdkVersion = "21.0.4";
        hash =
          if enableJavaFX then
            "sha256-H3gM2XCCcuUxlAEzX6IO7Cp6NtH85PYHlH54k5XvNAc="
          else
            "sha256-XOdaaiR8cCm3TEynz29g/SstaM4eiVb7RI0phDFrX+o=";
      };

      aarch64-darwin = {
        zuluVersion = "21.36.17";
        jdkVersion = "21.0.4";
        hash =
          if enableJavaFX then
            "sha256-lLAb8MABo95A5WcayBLNvsBSdVFptnO4EmhX2gjo6r8="
          else
            "sha256-vCdQ+BoWbMbpwwroqrpU8lOoyOydjPwEpVX+IHEse/8=";
      };
    };
  }
  // builtins.removeAttrs args [ "callPackage" ]
)
