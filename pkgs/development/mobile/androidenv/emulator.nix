{
  deployAndroidPackage,
  lib,
  package,
  os,
  autoPatchelfHook,
  makeWrapper,
  pkgs,
  pkgsi686Linux,
  postInstall,
}:

deployAndroidPackage {
  inherit package os;
  nativeBuildInputs = [ makeWrapper ] ++ lib.optionals (os == "linux") [ autoPatchelfHook ];
  buildInputs =
    lib.optionals (os == "linux") (
      with pkgs;
      [
        glibc
        libcxx
        libGL
        libpulseaudio
        libtiff
        libuuid
        zlib
        libbsd
        ncurses5
        libdrm
        stdenv.cc.cc
        pkgsi686Linux.glibc
        expat
        freetype
        nss
        nspr
        alsa-lib
      ]
    )
    ++ (with pkgs.xorg; [
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
      libICE
      libSM
      libxkbfile
    ]);
  patchInstructions = lib.optionalString (os == "linux") ''
    addAutoPatchelfSearchPath $packageBaseDir/lib
    addAutoPatchelfSearchPath $packageBaseDir/lib64
    addAutoPatchelfSearchPath $packageBaseDir/lib64/qt/lib
    # autoPatchelf is not detecting libuuid :(
    addAutoPatchelfSearchPath ${pkgs.libuuid.out}/lib

    # This library is linked against a version of libtiff that nixpkgs doesn't have
    for file in $out/libexec/android-sdk/emulator/*/qt/plugins/imageformats/libqtiffAndroidEmu.so; do
      patchelf --replace-needed libtiff.so.5 libtiff.so "$file" || true
    done

    autoPatchelf $out

    # Wrap emulator so that it can load required libraries at runtime
    wrapProgram $out/libexec/android-sdk/emulator/emulator \
      --prefix LD_LIBRARY_PATH : ${
        lib.makeLibraryPath [
          pkgs.dbus
          pkgs.systemd
        ]
      } \
      --set QT_XKB_CONFIG_ROOT ${pkgs.xkeyboard_config}/share/X11/xkb \
      --set QTCOMPOSE ${pkgs.xorg.libX11.out}/share/X11/locale

    mkdir -p $out/bin
    cd $out/bin
    find $out/libexec/android-sdk/emulator -type f -executable -mindepth 1 -maxdepth 1 | while read i; do
      ln -s $i
    done

    cd $out/libexec/android-sdk
    ${postInstall}
  '';
  dontMoveLib64 = true;
}
