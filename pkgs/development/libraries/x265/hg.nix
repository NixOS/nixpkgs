{ callPackage, ... } @ args:

callPackage ./generic.nix (args // rec {
  version = "2015-2-11"; # Date of commit used Y-M-D
  rev = "9ab104096834f51bd799ea1cf1160092f8182944";
  sha256 = "1j4k6ylglrzng5rz29qx2z06amdrq8wyzvqhm4ivfzvpndfniim6";
})