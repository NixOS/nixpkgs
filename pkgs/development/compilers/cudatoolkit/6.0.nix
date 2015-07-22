{ callPackage, ... } @ args:

callPackage ./generic.nix (args // rec {
  version = "6.0.37";
  sha256 = "991e436c7a6c94ec67cf44204d136adfef87baa3ded270544fa211179779bc40";
})
