{deployAndroidPackage, lib, package, autoPatchelfHook, makeWrapper, os, pkgs, pkgs_i686, postInstall ? ""}:

deployAndroidPackage {
  name = "androidsdk";
  inherit os package;
  buildInputs = [ autoPatchelfHook makeWrapper ]
    ++ lib.optional (os == "linux") [ pkgs.glibc pkgs.xlibs.libX11 pkgs.xlibs.libXrender pkgs.xlibs.libXext pkgs.fontconfig pkgs.freetype pkgs_i686.glibc pkgs_i686.xlibs.libX11 pkgs_i686.xlibs.libXrender pkgs_i686.xlibs.libXext pkgs_i686.fontconfig.lib pkgs_i686.freetype pkgs_i686.zlib pkgs.fontconfig.lib ];

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
      --prefix LD_LIBRARY_PATH : ${lib.makeLibraryPath [ pkgs.xlibs.libX11 pkgs.xlibs.libXtst ]}

    # Patch all script shebangs
    patchShebangs .

    cd ..
    ${postInstall}
  '';

  meta.licenses = lib.licenses.unfree;
}
