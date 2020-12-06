{deployAndroidPackage, lib, package, os, autoPatchelfHook, pkgs}:

deployAndroidPackage {
  inherit package os;
  buildInputs = [ autoPatchelfHook ]
    ++ lib.optionals (os == "linux") [ pkgs.glibc pkgs.zlib pkgs.ncurses5 ];
  patchInstructions = lib.optionalString (os == "linux") ''
    addAutoPatchelfSearchPath $packageBaseDir/lib64
    autoPatchelf --no-recurse $packageBaseDir/lib64
    autoPatchelf --no-recurse $packageBaseDir
  '' + ''
    mkdir -p $out/bin
    cd $out/bin
    find $out/libexec/android-sdk/platform-tools -type f -executable -mindepth 1 -maxdepth 1 -not -name sqlite3 | while read i
    do
        ln -s $i
    done
  '';
}
