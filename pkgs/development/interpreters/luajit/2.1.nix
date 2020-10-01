{ self, callPackage }:
callPackage ./default.nix {
  inherit self;
  version = "2.1.0-2020-09-30";
  rev = "e9af1ab";
  isStable = false;
  sha256 = "081vrr4snr1c38cscbq1a8barv7abc9czqqlm4qlbdksa8g32bbj";
}
