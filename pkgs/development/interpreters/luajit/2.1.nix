{ self, callPackage }:
callPackage ./default.nix {
  inherit self;
  version = "2.1.0-2020-08-05";
  rev = "10ddae7";
  isStable = false;
  sha256 = "1lmjs0gz9vgbhh5f45jvvibpj7f3sz81r8cz4maln9yhc67f2zmk";
}
