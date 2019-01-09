{deployAndroidPackage, lib, package, os, autoPatchelfHook, makeWrapper, pkgs, pkgs_i686}:

deployAndroidPackage {
  inherit package os;
  buildInputs = [ autoPatchelfHook makeWrapper ]
    ++ lib.optional (os == "linux") [ pkgs.glibc pkgs.xlibs.libX11 pkgs.xlibs.libXext pkgs.xlibs.libXdamage pkgs.xlibs.libXfixes pkgs.xlibs.libxcb pkgs.libGL pkgs.libpulseaudio pkgs.zlib pkgs.ncurses5 pkgs.stdenv.cc.cc pkgs_i686.glibc ];
  patchInstructions = lib.optionalString (os == "linux") ''
    addAutoPatchelfSearchPath $packageBaseDir/lib
    addAutoPatchelfSearchPath $packageBaseDir/lib64
    addAutoPatchelfSearchPath $packageBaseDir/lib64/qt/lib
    autoPatchelf $out

    # Wrap emulator so that it can load libdbus-1.so at runtime and it no longer complains about XKB keymaps
    wrapProgram $out/libexec/android-sdk/emulator/emulator \
      --prefix LD_LIBRARY_PATH : ${lib.makeLibraryPath [ pkgs.dbus ]} \
      --set QT_XKB_CONFIG_ROOT ${pkgs.xkeyboard_config}/share/X11/xkb \
      --set QTCOMPOSE ${pkgs.xorg.libX11.out}/share/X11/locale
  '';
  dontMoveLib64 = true;
}
