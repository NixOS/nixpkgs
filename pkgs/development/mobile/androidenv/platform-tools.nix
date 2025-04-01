{
  deployAndroidPackage,
  lib,
  package,
  os,
  arch,
  autoPatchelfHook,
  pkgs,
  meta,
}:

deployAndroidPackage {
  inherit package os arch;
  nativeBuildInputs = lib.optionals (os == "linux") [ autoPatchelfHook ];
  buildInputs = lib.optionals (os == "linux") [
    pkgs.glibc
    (lib.getLib pkgs.stdenv.cc.cc)
    pkgs.zlib
    pkgs.ncurses5
  ];

  patchInstructions =
    lib.optionalString (os == "linux") ''
      addAutoPatchelfSearchPath $packageBaseDir/lib64
      autoPatchelf --no-recurse $packageBaseDir/lib64
      autoPatchelf --no-recurse $packageBaseDir
    ''
    + ''
      mkdir -p $out/bin
      cd $out/bin
      find $out/libexec/android-sdk/platform-tools -type f -executable -mindepth 1 -maxdepth 1 -not -name sqlite3 | while read i
      do
          ln -s $i
      done
    '';
  inherit meta;
}
