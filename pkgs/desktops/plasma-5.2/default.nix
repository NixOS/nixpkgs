# Maintainer's Notes:
#
# Minor updates:
#  1. Edit ./manifest.sh to point to the updated URL. Upstream sometimes
#     releases updates that include only the changed packages; in this case,
#     multiple URLs can be provided and the results will be merged.
#  2. Run ./manifest.sh and ./dependencies.sh.
#  3. Build and enjoy.
#
# Major updates:
#  We prefer not to immediately overwrite older versions with major updates, so
#  make a copy of this directory first. After copying, be sure to delete ./tmp
#  if it exists. Then follow the minor update instructions.

{ autonix, kf56, pkgs, stdenv, debug ? false }:

with stdenv.lib; with autonix;

let

  kf5 = kf56.override { inherit debug; };

  inherit (kf5) qt5;

  mirror = "mirror://kde";

  renames =
    builtins.removeAttrs
      (import ./renames.nix {})
      ["Backend" "CTest"];

  scope =
    # packages in this collection
    (mapAttrs (dep: name: plasma5."${name}") renames) //
    # packages from KDE Frameworks 5
    kf5.scope //
    # packages pinned to this version of Qt 5
    {
      LibBlueDevil = pkgs.libbluedevil;
      PolkitQt5-1 = pkgs.polkit_qt5.override { inherit qt5; };
      PopplerQt5 = (pkgs.poppler.override { inherit (kf5) qt5; }).poppler_qt5;
    } //
    # packages from nixpkgs
    (with pkgs;
      {
        inherit epoxy;
        Epub = ebook_tools;
        Exiv2 = exiv2;
        FFmpeg = ffmpeg;
        FONTFORGE_EXECUTABLE = fontforge;
        Freetype = freetype;
        GTK2 = gtk2;
        GTK3 = gtk3;
        Libinput = libinput;
        LibSSH = libssh;
        ModemManager = modemmanager;
        NetworkManager = networkmanager;
        PulseAudio = pulseaudio;
        Taglib = taglib;
        USB = libusb;
        Wayland = wayland;
        Xapian = xapian;
      }
    );

  preResolve = super:
    fold (f: x: f x) super
      [
        (userEnvPkg "SharedMimeInfo")
        (userEnvPkg "SharedDesktopOntologies")
        (blacklist ["bluedevil"])
      ];

  postResolve = super:
    (builtins.removeAttrs super ["breeze"]) // {

      breeze-qt4 = with pkgs; super.breeze // {
        name = "breeze-qt4-" + (builtins.parseDrvName super.breeze.name).version;
        buildInputs = [ xlibs.xproto kde4.kdelibs qt4 ];
        nativeBuildInputs = [ cmake pkgconfig ];
        cmakeFlags =
          [
            "-DUSE_KDE4=ON"
            "-DQT_QMAKE_EXECUTABLE=${qt4}/bin/qmake"
          ];
      };

      breeze-qt5 = with pkgs; super.breeze // {
        name = "breeze-qt5-" + (builtins.parseDrvName super.breeze.name).version;
        buildInputs = with kf5; with plasma5;
          [
            kcompletion kconfig kconfigwidgets kcoreaddons kdecoration
            frameworkintegration ki18n kwindowsystem qt5
          ];
        nativeBuildInputs = [ cmake kf5.extra-cmake-modules pkgconfig ];
        cmakeFlags = [ "-DUSE_KDE4=OFF" ];
      };

      kde-gtk-config = with pkgs; super.kde-gtk-config // {
        NIX_CFLAGS_COMPILE =
          (super.kde-gtk-config.NIX_CFLAGS_COMPILE or "")
          + " -I${cairo}/include/cairo"
          + " -I${gtk2}/include/gtk-2.0 -I${gtk2}/lib/gtk-2.0/include"
          + " -I${glib}/include/glib-2.0 -I${glib}/lib/glib-2.0/include"
          + " -I${pango}/include/pango-1.0";
      };

      kwin = with pkgs; super.kwin // {
        buildInputs = with xlibs;
          super.kwin.buildInputs ++ [ libICE libSM libXcursor ];
        patches = [ ./kwin/kwin-import-plugin-follow-symlinks.patch ];
      };

      libkscreen = with pkgs; super.libkscreen // {
        buildInputs = with xlibs; super.libkscreen.buildInputs ++ [libXrandr];
      };

      plasma-desktop = with pkgs; super.plasma-desktop // {
        buildInputs = with xlibs;
          super.plasma-desktop.buildInputs ++
          [ pkgs.libcanberra libxkbfile libXcursor libXft ];
        patches = [
          ./plasma-desktop/plasma-desktop-hwclock.patch
          ./plasma-desktop/plasma-desktop-zoneinfo.patch
        ];
        preConfigure = ''
          substituteInPlace kcms/dateandtime/helper.cpp \
            --subst-var-by hwclock "${utillinux}/sbin/hwclock"
        '';
      };

      plasma-workspace = with pkgs; super.plasma-workspace // {
        buildInputs = with xlibs;
          super.plasma-workspace.buildInputs ++ [ libSM libXcursor pam ];
        postInstall = ''
          # We use a custom startkde script
          rm $out/bin/startkde
        '';
      };

      powerdevil = with pkgs; super.powerdevil // {
        buildInputs = with xlibs; super.powerdevil.buildInputs ++ [libXrandr];
      };

      sddm-kcm = with pkgs; super.sddm-kcm // {
        buildInputs = with xlibs; super.sddm-kcm.buildInputs ++ [libXcursor];
      };

    };

  plasma5 = generateCollection ./. {
    inherit (kf5) mkDerivation;
    inherit mirror preResolve postResolve renames scope;
  };

in
  plasma5 // {
    inherit scope;
    startkde = pkgs.callPackage ./startkde {
      inherit (kf5) kconfig kinit kservice;
      inherit (plasma5) plasma-desktop plasma-workspace;
    };
  }
