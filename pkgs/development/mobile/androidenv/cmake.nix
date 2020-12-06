{deployAndroidPackage, lib, package, os, autoPatchelfHook, pkgs}:

deployAndroidPackage {
  inherit package os;
  buildInputs = [ autoPatchelfHook ]
    ++ lib.optional (os == "linux") [ pkgs.stdenv.glibc pkgs.stdenv.cc.cc ];
  patchInstructions = lib.optionalString (os == "linux") ''
    autoPatchelf $packageBaseDir/bin
  '';
}
