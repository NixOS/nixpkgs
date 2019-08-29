{deployAndroidPackage, lib, package, os, autoPatchelfHook, pkgs}:

deployAndroidPackage {
  inherit package os;
  buildInputs = [ autoPatchelfHook ]
    ++ lib.optional (os == "linux") [ pkgs.glibc pkgs.stdenv.cc.cc pkgs.zlib pkgs.openssl.out pkgs.ncurses5 ];
  patchInstructions = lib.optionalString (os == "linux") ''
    addAutoPatchelfSearchPath $packageBaseDir/lib
    autoPatchelf $packageBaseDir/lib
    autoPatchelf $packageBaseDir/bin
  '';
}
