{deployAndroidPackage, lib, package, autoPatchelfHook, makeWrapper, os, pkgs, pkgs_i686, postInstall ? ""}:

deployAndroidPackage {
  name = "androidsdk";
  inherit os package;
  buildInputs = [ autoPatchelfHook makeWrapper ]
    ++ lib.optional (os == "linux") [ pkgs.glibc pkgs.xorg.libX11 pkgs.xorg.libXrender pkgs.xorg.libXext pkgs.fontconfig pkgs.freetype pkgs_i686.glibc pkgs_i686.xorg.libX11 pkgs_i686.xorg.libXrender pkgs_i686.xorg.libXext pkgs_i686.fontconfig.lib pkgs_i686.freetype pkgs_i686.zlib pkgs.fontconfig.lib ];

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

  meta.licenses = lib.licenses.unfree;
}
