{
  callPackage,
  enableJavaFX ? false,
  ...
}@args:

callPackage ./common.nix (
  {
    # The Darwin implementation of openjdk27.
    # https://www.azul.com/downloads/?version=java-27&package=jdk
    dists.aarch64-darwin = {
      zuluVersion = if enableJavaFX then "27.28.103" else "27.28.101";
      jdkVersion = "27.0.0";
      hash =
        if enableJavaFX then
          "sha256-aDIfK8RxhPvP9qEvJn3Yh1Lytwv4lWGwlup7BtCsKyc="
        else
          "sha256-DY8dGRL6k469lUmeseiiqYdyX+QqoN2YSXu2BHSKjQc=";
    };
  }
  // removeAttrs args [ "callPackage" ]
)
