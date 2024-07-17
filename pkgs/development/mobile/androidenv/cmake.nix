{
  deployAndroidPackage,
  lib,
  package,
  os,
  autoPatchelfHook,
  pkgs,
  stdenv,
}:

deployAndroidPackage {
  inherit package os;
  nativeBuildInputs = lib.optionals stdenv.isLinux [ autoPatchelfHook ];
  buildInputs = lib.optionals (os == "linux") [
    pkgs.stdenv.cc.libc
    pkgs.stdenv.cc.cc
    pkgs.ncurses5
  ];
  patchInstructions = lib.optionalString (os == "linux") ''
    autoPatchelf $packageBaseDir/bin
  '';
}
