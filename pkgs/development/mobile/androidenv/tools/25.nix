{deployAndroidPackage, lib, package, autoPatchelfHook, makeWrapper, os, pkgs, pkgs_i686, postInstall ? ""}:

deployAndroidPackage {
  name = "androidsdk";
  buildInputs = [ autoPatchelfHook makeWrapper ]
    ++ lib.optional (os == "linux") [ pkgs.glibc pkgs.xlibs.libX11 pkgs.xlibs.libXext pkgs.xlibs.libXdamage pkgs.xlibs.libxcb pkgs.xlibs.libXfixes pkgs.xlibs.libXrender pkgs.fontconfig.lib pkgs.freetype pkgs.libGL pkgs.zlib pkgs.ncurses5 pkgs.libpulseaudio pkgs_i686.glibc pkgs_i686.xlibs.libX11 pkgs_i686.xlibs.libXrender pkgs_i686.fontconfig pkgs_i686.freetype pkgs_i686.zlib ];
  inherit package os;

  patchInstructions = ''
    ${lib.optionalString (os == "linux") ''
      # Auto patch all binaries
      addAutoPatchelfSearchPath $PWD/lib64
      addAutoPatchelfSearchPath $PWD/lib64/libstdc++
      addAutoPatchelfSearchPath $PWD/lib64/qt/lib
      addAutoPatchelfSearchPath $PWD/lib
      addAutoPatchelfSearchPath $PWD/lib/libstdc++
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

    # Wrap programs that require java
    for i in draw9patch jobb lint screenshot2
    do
        wrapProgram $PWD/$i \
          --prefix PATH : ${pkgs.jdk8}/bin
    done

    # Wrap programs that require java and SWT
    for i in android ddms hierarchyviewer monitor monkeyrunner traceview uiautomatorviewer
    do
        wrapProgram $PWD/$i \
          --prefix PATH : ${pkgs.jdk8}/bin \
          --prefix LD_LIBRARY_PATH : ${lib.makeLibraryPath [ pkgs.xlibs.libX11 pkgs.xlibs.libXtst ]}
    done

    ${lib.optionalString (os == "linux") ''
      wrapProgram $PWD/emulator \
        --prefix PATH : ${pkgs.file}/bin:${pkgs.glxinfo}/bin:${pkgs.pciutils}/bin \
        --set QT_XKB_CONFIG_ROOT ${pkgs.xkeyboard_config}/share/X11/xkb \
        --set QTCOMPOSE ${pkgs.xorg.libX11.out}/share/X11/locale
    ''}

    # Patch all script shebangs
    patchShebangs .

    cd ..
    ${postInstall}
  '';

  meta.licenses = lib.licenses.unfree;
}
