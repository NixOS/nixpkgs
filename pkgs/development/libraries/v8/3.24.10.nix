{ callPackage, ... } @ args:

callPackage ./generic.nix (args // {
  version = "3.24.10";
  sha256 = "1blz5h9syk93bb4x3shcai3s2jhh6ai4bpymr9rz0f1ysvg60x75";
})
