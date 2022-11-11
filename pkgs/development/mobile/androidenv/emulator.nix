{ deployAndroidPackage, lib, package, os, autoPatchelfHook, makeWrapper, pkgs, pkgs_i686 }:

deployAndroidPackage {
  inherit package os;
  nativeBuildInputs = [ makeWrapper ]
    ++ lib.optionals (os == "linux") [ autoPatchelfHook ];
  buildInputs = lib.optionals (os == "linux") (with pkgs; [
      glibc
      libcxx
      libGL
      libpulseaudio
      libuuid
      zlib
      ncurses5
      stdenv.cc.cc
      pkgs_i686.glibc
      expat
      freetype
      nss
      nspr
      alsa-lib
    ]) ++ (with pkgs.xorg; [
      libX11
      libXext
      libXdamage
      libXfixes
      libxcb
      libXcomposite
      libXcursor
      libXi
      libXrender
      libXtst
    ]);
  patchInstructions = lib.optionalString (os == "linux") ''
    addAutoPatchelfSearchPath $packageBaseDir/lib
    addAutoPatchelfSearchPath $packageBaseDir/lib64
    addAutoPatchelfSearchPath $packageBaseDir/lib64/qt/lib
    # autoPatchelf is not detecting libuuid :(
    addAutoPatchelfSearchPath ${pkgs.libuuid.out}/lib
    autoPatchelf $out

    # Wrap emulator so that it can load required libraries at runtime
    wrapProgram $out/libexec/android-sdk/emulator/emulator \
      --prefix LD_LIBRARY_PATH : ${lib.makeLibraryPath [
        pkgs.dbus
        pkgs.systemd
      ]} \
      --set QT_XKB_CONFIG_ROOT ${pkgs.xkeyboard_config}/share/X11/xkb \
      --set QTCOMPOSE ${pkgs.xorg.libX11.out}/share/X11/locale
  '';
  dontMoveLib64 = true;
}
