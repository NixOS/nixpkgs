{deployAndroidPackage, lib, package, autoPatchelfHook, makeWrapper, os, pkgs, pkgsi686Linux, postInstall}:

deployAndroidPackage {
  name = "androidsdk";
  inherit os package;
  nativeBuildInputs = [ makeWrapper ]
    ++ lib.optionals (os == "linux") [ autoPatchelfHook ];
  buildInputs = lib.optional (os == "linux") (
      (with pkgs; [ glibc freetype fontconfig fontconfig.lib
        stdenv.cc.cc.libgcc or null # fix for https://github.com/NixOS/nixpkgs/issues/226357
      ])
      ++ (with pkgs.xorg; [ libX11 libXrender libXext ])
      ++ (with pkgsi686Linux; [ glibc xorg.libX11 xorg.libXrender xorg.libXext fontconfig.lib freetype zlib ])
    );

  patchInstructions = ''
    ${lib.optionalString (os == "linux") ''
      # Auto patch all binaries
      autoPatchelf .
    ''}

    # Wrap all scripts that require JAVA_HOME
    for i in bin; do
      find $i -maxdepth 1 -type f -executable | while read program; do
        if grep -q "JAVA_HOME" $program; then
          wrapProgram $PWD/$program --prefix PATH : ${pkgs.jdk8}/bin
        fi
      done
    done

    # Wrap monitor script
    wrapProgram $PWD/monitor \
      --prefix PATH : ${pkgs.jdk8}/bin \
      --prefix LD_LIBRARY_PATH : ${lib.makeLibraryPath (with pkgs; [ xorg.libX11 xorg.libXtst ])}

    # Patch all script shebangs
    patchShebangs .

    cd $out/libexec/android-sdk
    ${postInstall}
  '';

  meta.license = lib.licenses.unfree;
}
