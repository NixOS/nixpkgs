{ self, callPackage }:
callPackage ./default.nix {
  inherit self;
  version = "2.1.0-2021-05-22";
  rev = "5783ba1bf73c53ca56e64ed0c462c62224f0393c";
  isStable = false;
  sha256 = "1j25xnbradks58lwsqnxcc7k29wsk2hnky0b1vjzpadrj0sxxc42";
}
