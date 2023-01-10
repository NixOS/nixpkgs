{deployAndroidPackage, lib, package, os, autoPatchelfHook, makeWrapper, pkgs, pkgsi686Linux}:

deployAndroidPackage {
  inherit package os;
  nativeBuildInputs = [ makeWrapper ]
    ++ lib.optionals (os == "linux") [ autoPatchelfHook ];
  buildInputs = lib.optionals (os == "linux") [ pkgs.glibc pkgs.zlib pkgs.ncurses5 pkgsi686Linux.glibc pkgsi686Linux.zlib pkgsi686Linux.ncurses5 pkgs.libcxx ];
  patchInstructions = ''
    ${lib.optionalString (os == "linux") ''
      addAutoPatchelfSearchPath $packageBaseDir/lib
      if [[ -d $packageBaseDir/lib64 ]]; then
        addAutoPatchelfSearchPath $packageBaseDir/lib64
        autoPatchelf --no-recurse $packageBaseDir/lib64
      fi
      autoPatchelf --no-recurse $packageBaseDir
    ''}

    ${lib.optionalString (lib.toInt (lib.versions.major package.revision) < 33) ''
      wrapProgram $PWD/mainDexClasses \
        --prefix PATH : ${pkgs.jdk8}/bin
    ''}
  '';
  noAuditTmpdir = true; # The checker script gets confused by the build-tools path that is incorrectly identified as a reference to /build
}
