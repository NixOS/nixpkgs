{ self, callPackage }:
callPackage ./default.nix {
  inherit self;
  version = "2.1.0-2020-08-27";
  rev = "ff1e72a";
  isStable = false;
  sha256 = "0rlh5y48jbxnamr3a5i3szzh7y9ycvq052rw6m82gdhrb1jlamdz";
}
