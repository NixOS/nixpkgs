{ callPackage, stdenv, overrideCC, rocr, llvm, clang, lld }:

callPackage ./generic.nix {
  inherit clang lld llvm rocr;
  stdenv = overrideCC stdenv clang;
  tagPrefix = "rocm-ocl";
  sha256 = "0h4aggj2766gm3grz387nbw3bn0l461walgkzmmly9a5shfc36ah";
}
