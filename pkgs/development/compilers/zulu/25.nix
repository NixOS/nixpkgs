{
  callPackage,
  enableJavaFX ? false,
  ...
}@args:

let
  # For Zulu 25, FX and non-FX versions can differ
  zuluVersion = if enableJavaFX then "25.34.17" else "25.34.17";
  jdkVersion = "25.0.3";
  # The November security update is available for the plain Linux JDK.
  linuxZuluVersion = if enableJavaFX then zuluVersion else "25.38.201";
  linuxJdkVersion = if enableJavaFX then jdkVersion else "25.0.5.1";
in
callPackage ./common.nix (
  {
    # Details from https://www.azul.com/downloads/?version=java-24&package=jdk
    # Note that the latest build may differ by platform
    dists = {
      x86_64-linux = {
        zuluVersion = linuxZuluVersion;
        jdkVersion = linuxJdkVersion;
        hash =
          if enableJavaFX then
            "sha256-gL7WgJFifVy3wYYqLFE13c7GZ6YMi3BVWhL+1+yTFN8="
          else
            "sha256-/Ho9k5a0QxNGZrnPfNlGtTLcF4H1NQxyWEmsUNFqcZg=";
      };

      aarch64-linux = {
        zuluVersion = linuxZuluVersion;
        jdkVersion = linuxJdkVersion;
        hash =
          if enableJavaFX then
            "sha256-K/vR9QBMbtW3KBePsoyIas9l64s6hf/uMuhAm53himE="
          else
            "sha256-fww1aBPeMV26xE0aKi1hpcq51qyPLN/24yyZS+XALaE=";
      };

      aarch64-darwin = {
        inherit zuluVersion jdkVersion;
        hash =
          if enableJavaFX then
            "sha256-/aWoDAXxCtXhGcsZCDjJe+hvIwHANZSw8NkBbjpgklk="
          else
            "sha256-dIR+eskwrRQ5UGB0Id1sCnzLPRy72LFmXySrYri33kI=";
      };
    };
  }
  // removeAttrs args [ "callPackage" ]
)
