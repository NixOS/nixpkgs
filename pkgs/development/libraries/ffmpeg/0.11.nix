{ callPackage, ... } @ args:

callPackage ./generic.nix (args // rec {
  version = "${branch}.5";
  branch = "0.11";
  sha256 = "1h5qwn4h7sppqw36hri5p6zlv2387vwaxh2pyj070xfn8hgrk4ll";
})
