{deployAndroidPackage, lib, stdenv, package, os, autoPatchelfHook, makeWrapper, pkgs, pkgsi686Linux, postInstall}:

deployAndroidPackage {
  inherit package;
  nativeBuildInputs = [ makeWrapper ]
    ++ lib.optionals (os == "linux") [ autoPatchelfHook ];
  buildInputs = lib.optionals (os == "linux") [ pkgs.glibc pkgs.zlib pkgs.ncurses5 pkgs.libcxx ]
    ++ lib.optionals (os == "linux" && stdenv.isx86_64) (with pkgsi686Linux; [ glibc zlib ncurses5 ]);
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

    cd $out/libexec/android-sdk
  '' + postInstall;
  noAuditTmpdir = true; # The checker script gets confused by the build-tools path that is incorrectly identified as a reference to /build
}
