{deployAndroidPackage, lib, package, os, autoPatchelfHook, pkgs, path}:

deployAndroidPackage {
  inherit package os;
  nativeBuildInputs = lib.optionals (os == "linux") [ autoPatchelfHook ];
  buildInputs = lib.optionals (os == "linux") (with pkgs; [
    llvmPackages_19.libcxx alsa-lib zlib ncurses5
    (lib.getLib pkgs.stdenv.cc.cc)
  ]);

  patchInstructions = lib.optionalString (os == "linux") ''
    autoPatchelf --no-recurse $packageBaseDir

    mkdir -p $out/bin
    cd $out/bin
    find $out/libexec/android-sdk/${path} -type f -executable -mindepth 1 -maxdepth 1 | while read i
    do
        ln -s $i
    done
  '';
}
