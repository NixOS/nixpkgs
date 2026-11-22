{
  callPackage,
  fetchurl,
  fetchpatch2,
  ...
}@args:

callPackage ./unwrapped.nix (
  rec {
    version = "0.102";
    src = fetchurl {
      url = "https://downloads.factorcode.org/releases/${version}/factor-src-${version}.zip";
      hash = "sha256-bQDrq9sYWkCiUlELze0zGgW56DMMXckKGBpjVaMuOrU=";
    };
    patches = [
      # enables multi-line shebangs for nix-shell
      (fetchpatch2 {
        url = "https://github.com/factor/factor/commit/340ab9de8345e6e25dacb11fbfe07d78d3840f36.patch";
        hash = "sha256-zOSfGQA68YxxvuFf+4xKew40GTRCsMOlXCgHNvob+RM=";
      })
    ];
  }
  // (builtins.removeAttrs args [
    "callPackage"
    "fetchurl"
    "fetchpatch2"
  ])
)
