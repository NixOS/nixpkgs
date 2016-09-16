{ callPackage, ... } @ args:

callPackage ./generic.nix (args // {
  version = "1.1.1";
  sha256 = "1185ixlhhwpkqvwhnhrzgply03zq8mycj25m1am9aad8nshiaw3j";
})
