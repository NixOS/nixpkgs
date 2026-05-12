{
  callPackage,
  enableJavaFX ? false,
  ...
}@args:

let
  # For Zulu 25, FX and non-FX versions can differ
  zuluVersion = if enableJavaFX then "25.34.17" else "25.34.17";
  jdkVersion = "25.0.3";
in
callPackage ./common.nix (
  {
    # Details from https://www.azul.com/downloads/?version=java-24&package=jdk
    # Note that the latest build may differ by platform
    dists = {
      x86_64-linux = {
        inherit zuluVersion jdkVersion;
        hash =
          if enableJavaFX then
            "sha256-gL7WgJFifVy3wYYqLFE13c7GZ6YMi3BVWhL+1+yTFN8="
          else
            "sha256-OpMjX05bMTIyZHkWIZ6R3FzKC5g1ybUqQEuljENXFpc=";
      };

      aarch64-linux = {
        inherit zuluVersion jdkVersion;
        hash =
          if enableJavaFX then
            "sha256-K/vR9QBMbtW3KBePsoyIas9l64s6hf/uMuhAm53himE="
          else
            "sha256-JhDlxk35TO5ftZHXAYPFv4Uy2OHTlMdU6LoGdRvM6xs=";
      };

      x86_64-darwin = {
        inherit zuluVersion jdkVersion;
        hash =
          if enableJavaFX then
            "sha256-jOSgISihoNoGa5x8kBUpudCQi7Vj3O3H3jOG3W3UujA="
          else
            "sha256-7MAFv3sSnANTeeDem+v9ZnvpMJj18eMpzUmMRnaRZ64=";
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
