{ stdenv, callPackage, Foundation, libobjc }:

callPackage ./generic-cmake.nix (rec {
  inherit Foundation libobjc;
  version = "5.4.1.6";
  sha256 = "1pv5lmyxjr8z9s17jx19850k43ylzqlbzsgr5jxj1knmkbza1zdx";
  enableParallelBuilding = false; # #32386, https://hydra.nixos.org/build/65820147
})
