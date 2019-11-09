{deployAndroidPackage, lib, package, os, autoPatchelfHook, makeWrapper, pkgs, pkgs_i686}:

deployAndroidPackage {
  inherit package os;
  buildInputs = [ autoPatchelfHook makeWrapper ] ++
    lib.optionals (os == "linux") [ pkgs.glibc pkgs.zlib pkgs.ncurses5 pkgs_i686.glibc pkgs_i686.zlib pkgs_i686.ncurses5 ];
  patchInstructions = ''
    ${lib.optionalString (os == "linux") ''
      addAutoPatchelfSearchPath $packageBaseDir/lib
      addAutoPatchelfSearchPath $packageBaseDir/lib64
      autoPatchelf --no-recurse $packageBaseDir/lib64
      autoPatchelf --no-recurse $packageBaseDir
    ''}

    wrapProgram $PWD/mainDexClasses \
      --prefix PATH : ${pkgs.jdk8}/bin
  '';
  noAuditTmpdir = true; # The checker script gets confused by the build-tools path that is incorrectly identified as a reference to /build
}
