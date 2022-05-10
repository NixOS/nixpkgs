{deployAndroidPackage, lib, package, os, autoPatchelfHook, pkgs}:

deployAndroidPackage {
  inherit package os;
  nativeBuildInputs = [ autoPatchelfHook ];
  buildInputs = lib.optional (os == "linux") [ pkgs.stdenv.cc.libc pkgs.stdenv.cc.cc pkgs.ncurses5 ];
  patchInstructions = lib.optionalString (os == "linux") ''
    autoPatchelf $packageBaseDir/bin
  '';
}
