{ callPackage, ... } @ args:

callPackage ./generic.nix (args // {
  version = "1.0.10";
  sha256 = "1x5gvajplmwx869avlpx8p3c12pzi6wkgqaxmj5049nvw57l00kl";
})
