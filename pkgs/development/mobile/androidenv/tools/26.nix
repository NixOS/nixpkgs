{deployAndroidPackage, lib, package, autoPatchelfHook, makeWrapper, os, pkgs, pkgs_i686, postInstall ? ""}:

deployAndroidPackage {
  name = "androidsdk";
  inherit os package;
  nativeBuildInputs = [ makeWrapper ]
    ++ lib.optionals (os == "linux") [ autoPatchelfHook ];
  buildInputs = lib.optional (os == "linux") (
      (with pkgs; [ glibc freetype fontconfig fontconfig.lib])
      ++ (with pkgs.xorg; [ libX11 libXrender libXext ])
      ++ (with pkgs_i686; [ glibc xorg.libX11 xorg.libXrender xorg.libXext fontconfig.lib freetype zlib ])
    );

  patchInstructions = ''
    ${lib.optionalString (os == "linux") ''
      # Auto patch all binaries
      autoPatchelf .
    ''}

    # Wrap all scripts that require JAVA_HOME
    for i in bin
    do
        find $i -maxdepth 1 -type f -executable | while read program
        do
            if grep -q "JAVA_HOME" $program
            then
                wrapProgram $PWD/$program --prefix PATH : ${pkgs.jdk8}/bin
            fi
        done
    done

    # Wrap monitor script
    wrapProgram $PWD/monitor \
      --prefix PATH : ${pkgs.jdk8}/bin \
      --prefix LD_LIBRARY_PATH : ${lib.makeLibraryPath [ pkgs.xorg.libX11 pkgs.xorg.libXtst ]}

    # Patch all script shebangs
    patchShebangs .

    cd ..
    ${postInstall}
  '';

  meta.license = lib.licenses.unfree;
}
