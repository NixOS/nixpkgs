{
  stdenv,
  lib,
  fetchurl,
  pulseaudioSupport ? true,
  xdgDesktopPortalSupport ? true,
  callPackage,
  buildFHSEnv,
}:

let
  unpacked = stdenv.mkDerivation (finalAttrs: {
    pname = "zoom";
    version = "6.4.6.1370";

    src = fetchurl {
      url = "https://zoom.us/client/${finalAttrs.version}/zoom_x86_64.pkg.tar.xz";
      hash = "sha256-Y+8garSqDcKLCVv1cTiqGEfrGKpK3UoXIq8X4E8CF+8=";
    };

    dontUnpack = true;

    # Note: In order to uncover missing libraries,
    # add "pkgs" to this file's arguments
    # (at the top of this file), then add these attributes here:
    # > buildInputs = linuxGetDependencies pkgs;
    # > dontAutoPatchelf = true;
    # > dontWrapQtApps = true;
    # > nativeBuildInputs = [ pkgs.autoPatchelfHook ];
    # > preFixup = ''
    # >   addAutoPatchelfSearchPath $out/opt/zoom
    # >   autoPatchelf $out/opt/zoom/{cef,Qt,*.so*,aomhost,zoom,zopen,ZoomLauncher,ZoomWebviewHost}
    # > '';
    # Then build `zoom-us.unpacked`:
    # `autoPatchelfHook` will report missing library files.

    installPhase = ''
      runHook preInstall
      mkdir $out
      tar -C $out -xf $src
      mv $out/usr/* $out/
      runHook postInstall
    '';

    dontPatchELF = true;

    passthru.updateScript = ./update.sh;
    passthru.tests.startwindow = callPackage ./test.nix { };

    meta = {
      homepage = "https://zoom.us/";
      changelog = "https://support.zoom.com/hc/en/article?id=zm_kb&sysparm_article=KB0061222";
      description = "zoom.us video conferencing application";
      sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
      license = lib.licenses.unfree;
      platforms = [ "x86_64-linux" ];
      maintainers = with lib.maintainers; [
        danbst
        tadfisher
      ];
    };
  });

  linuxGetDependencies =
    pkgs:
    [
      pkgs.alsa-lib
      pkgs.at-spi2-atk
      pkgs.at-spi2-core
      pkgs.atk
      pkgs.cairo
      pkgs.coreutils
      pkgs.cups
      pkgs.dbus
      pkgs.expat
      pkgs.fontconfig
      pkgs.freetype
      pkgs.gdk-pixbuf
      pkgs.glib
      pkgs.glib.dev
      pkgs.gtk3
      pkgs.libGL
      pkgs.libdrm
      pkgs.libgbm
      pkgs.libkrb5
      pkgs.libxkbcommon
      pkgs.nspr
      pkgs.nss
      pkgs.pango
      pkgs.pciutils
      pkgs.pipewire
      pkgs.procps
      pkgs.qt5.qt3d
      pkgs.qt5.qtgamepad
      pkgs.qt5.qtlottie
      pkgs.qt5.qtmultimedia
      pkgs.qt5.qtremoteobjects
      pkgs.qt5.qtxmlpatterns
      pkgs.stdenv.cc.cc
      pkgs.udev
      pkgs.util-linux
      pkgs.wayland
      pkgs.xorg.libX11
      pkgs.xorg.libXcomposite
      pkgs.xorg.libXdamage
      pkgs.xorg.libXext
      pkgs.xorg.libXfixes
      pkgs.xorg.libXrandr
      pkgs.xorg.libXrender
      pkgs.xorg.libXtst
      pkgs.xorg.libxcb
      pkgs.xorg.libxshmfence
      pkgs.xorg.xcbutilimage
      pkgs.xorg.xcbutilkeysyms
      pkgs.xorg.xcbutilrenderutil
      pkgs.xorg.xcbutilwm
      pkgs.zlib
    ]
    ++ lib.optionals pulseaudioSupport [
      pkgs.libpulseaudio
      pkgs.pulseaudio
    ]
    ++ lib.optionals xdgDesktopPortalSupport [
      pkgs.kdePackages.xdg-desktop-portal-kde
      pkgs.lxqt.xdg-desktop-portal-lxqt
      pkgs.plasma5Packages.xdg-desktop-portal-kde
      pkgs.xdg-desktop-portal
      pkgs.xdg-desktop-portal-gnome
      pkgs.xdg-desktop-portal-gtk
      pkgs.xdg-desktop-portal-hyprland
      pkgs.xdg-desktop-portal-wlr
      pkgs.xdg-desktop-portal-xapp
    ];

in

# We add the `unpacked` zoom archive to the FHS env
# and also bind-mount its `/opt` directory.
# This should assist Zoom in finding all its
# files in the places where it expects them to be.
buildFHSEnv rec {
  pname = "zoom"; # Will also be the program's name!
  inherit (unpacked) version;

  targetPkgs = pkgs: (linuxGetDependencies pkgs) ++ [ unpacked ];
  extraPreBwrapCmds = "unset QT_PLUGIN_PATH";
  extraBwrapArgs = [ "--ro-bind ${unpacked}/opt /opt" ];
  runScript = "/opt/zoom/ZoomLauncher";

  extraInstallCommands = ''
    cp -Rt $out/ ${unpacked}/share
    substituteInPlace \
        $out/share/applications/Zoom.desktop \
        --replace-fail Exec={/usr/bin/,}zoom

    # Backwards compatibility: we used to call it zoom-us
    ln -s $out/bin/{zoom,zoom-us}
  '';

  passthru = unpacked.passthru // {
    inherit unpacked;
  };
  meta = unpacked.meta // {
    mainProgram = pname;
  };
}
