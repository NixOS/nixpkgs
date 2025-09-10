{
  deployAndroidPackage,
  lib,
  package,
  os,
  arch,
  autoPatchelfHook,
  makeWrapper,
  pkgs,
  meta,
}:

deployAndroidPackage {
  inherit package os arch;
  nativeBuildInputs = [ makeWrapper ] ++ lib.optionals (os == "linux") [ autoPatchelfHook ];
  buildInputs = lib.optionals (os == "linux") (
    with pkgs;
    [
      llvmPackages.libcxx
      SDL2
    ]
  );

  patchInstructions = lib.optionalString (os == "linux") ''
    autoPatchelf --no-recurse $packageBaseDir

    if [ -f $PWD/desktop-head-unit ]; then
      echo "desktop-head-unit exists"
      wrapProgram $PWD/desktop-head-unit \
        --prefix LD_LIBRARY_PATH : ${
          lib.makeLibraryPath (
            with pkgs;
            [
              xorg.libX11
              xorg.libXrandr
            ]
          )
        }
    fi
  '';

  inherit meta;
}
