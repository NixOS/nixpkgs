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

{ pkgs, newScope, kdeApps ? null, kf5 ? null, qt5 ? null, debug ? false }:

let inherit (pkgs) autonix stdenv symlinkJoin; in

with autonix; let inherit (stdenv) lib; in

let
  kdeApps_ = if kdeApps != null then kdeApps else pkgs.kdeApps_15_04;
  kf5_ = if kf5 != null then kf5 else pkgs.kf510;
  qt5_ = if qt5 != null then qt5 else pkgs.qt54;
in

let

  kdeApps = kdeApps_.override { inherit debug kf5 qt5; plasma5 = self; };
  kf5 = kf5_.override { inherit debug qt5; };
  qt5 = qt5_;

  kdePackage = name: pkg:
    let defaultOverride = drv: drv // {
          setupHook = ./setup-hook.sh;
          cmakeFlags =
            (drv.cmakeFlags or [])
            ++ [ "-DBUILD_TESTING=OFF" ]
            ++ lib.optional debug "-DCMAKE_BUILD_TYPE=Debug";
          meta = {
            license = with stdenv.lib.licenses; [
              lgpl21Plus lgpl3Plus bsd2 mit gpl2Plus gpl3Plus fdl12
            ];
            platforms = stdenv.lib.platforms.linux;
            maintainers = with stdenv.lib.maintainers; [ ttuegel ];
            homepage = "http://www.kde.org";
          };
        };
        callPackage = newScope {
          inherit (stdenv) mkDerivation;
          inherit (pkgs) fetchurl;
          inherit scope;
        };
    in mkPackage callPackage defaultOverride name pkg;

  super =
    let json = builtins.fromJSON (builtins.readFile ./packages.json);
        mirrorUrl = n: pkg: pkg // {
          src = pkg.src // { url = "mirror://kde/${pkg.src.url}"; };
        };
        renames =
          (builtins.fromJSON (builtins.readFile ./kf5-renames.json))
          // (builtins.fromJSON (builtins.readFile ./renames.json));
        propagated = [ "extra-cmake-modules" ];
        native = [
          "bison"
          "extra-cmake-modules"
          "flex"
          "kdoctools"
          "ki18n"
          "libxslt"
          "perl"
          "pythoninterp"
        ];
        user = [
          "qt5"
          "qt5core"
          "qt5dbus"
          "qt5gui"
          "qt5qml"
          "qt5quick"
          "qt5svg"
          "qt5webkitwidgets"
          "qt5widgets"
          "qt5x11extras"
          "shareddesktopontologies"
          "sharedmimeinfo"
        ];
    in lib.fold (f: attrs: f attrs) json [
      (lib.mapAttrs kdePackage)
      (userEnvDeps user)
      (nativeDeps native)
      (propagateDeps propagated)
      (renameDeps renames)
      (lib.mapAttrs mirrorUrl)
    ];

  scope =
    # KDE Frameworks 5
    kf5 //
    # packages in this collection
    self //
    # packages pinned to this version of Qt 5
    {
      dbusmenu-qt5 = pkgs.libdbusmenu_qt5.override { inherit qt5; };
      libbluedevil = pkgs.libbluedevil.override { inherit qt5; };
      phonon4qt5 = pkgs.phonon_qt5.override { inherit qt5; };
      polkitqt5-1 = pkgs.polkit_qt5.override { inherit qt5; };
      poppler_qt5 = pkgs.poppler_qt5.override { inherit qt5; };
      qt5 = qt5.base;
      qt5core = qt5.base;
      qt5dbus = qt5.base;
      qt5gui = qt5.base;
      qt5linguisttools = qt5.tools;
      qt5qml = [qt5.declarative qt5.graphicaleffects];
      qt5quick = [qt5.quickcontrols qt5.graphicaleffects];
      qt5script = qt5.script;
      qt5svg = qt5.svg;
      qt5tools = qt5.tools;
      qt5webkitwidgets = qt5.webkit;
      qt5widgets = qt5.base;
      qt5x11extras = qt5.x11extras;
      qt5xmlpatterns = qt5.xmlpatterns;
    } //
    # packages from nixpkgs
    (with pkgs; {
      inherit attr bash cairo cmake coreutils dbus epoxy exiv2 ffmpeg
              freetype glib gnugrep gnused gtk2 gtk3 libinput libssh
              modemmanager openconnect openexr pam pango qt4 samba
              socat substituteAll taglib utillinux wayland xapian
              xkeyboard_config xorg;
      boost = boost155;
      canberra = libcanberra;
      epub = ebook_tools;
      fontforge_executable = fontforge;
      mobilebroadbandproviderinfo = mobile_broadband_provider_info;
      mtp = libmtp;
      pulseaudio = libpulseaudio;
      qalculate = libqalculate;
      shareddesktopontologies = shared_desktop_ontologies;
      sharedmimeinfo = shared_mime_info;
      usb = libusb;
    });

  self = super // {

    bluez-qt = overrideDerivation super.bluez-qt (drv: {
      preConfigure = ''
        substituteInPlace CMakeLists.txt \
          --replace /lib/udev/rules.d "$out/lib/udev/rules.d"
      '';
    });

    breeze =
      let
        version = (builtins.parseDrvName super.breeze.name).version;

        breeze-qt4 = overrideDerivation super.breeze (drv: {
          name = "breeze-qt4-${version}";
          buildInputs = [ pkgs.xorg.xproto pkgs.kde4.kdelibs pkgs.qt4 ];
          nativeBuildInputs = [ scope.cmake pkgs.pkgconfig ];
          cmakeFlags = [
            "-DUSE_KDE4=ON"
            "-DQT_QMAKE_EXECUTABLE=${scope.qt4}/bin/qmake"
          ];
        });

        breeze-qt5 = overrideDerivation super.breeze (drv: {
          name = "breeze-qt5-${version}";
          buildInputs = with kf5; with self; [
            kcompletion kconfig kconfigwidgets kcoreaddons kdecoration
            kguiaddons frameworkintegration ki18n kwindowsystem qt5.base
            qt5.x11extras
          ];
          nativeBuildInputs = [ scope.cmake kf5.extra-cmake-modules pkgs.pkgconfig ];
          cmakeFlags = [ "-DUSE_KDE4=OFF" ];
        });
      in symlinkJoin "breeze-${version}" [ breeze-qt4 breeze-qt5 ];

    kde-gtk-config = extendDerivation super.kde-gtk-config {
      NIX_CFLAGS_COMPILE = with scope;
        lib.concatStringsSep " " [
          "-I${cairo}/include/cairo"
          "-I${gtk2}/include/gtk-2.0"
          "-I${gtk2.out}/lib/gtk-2.0/include"
          "-I${glib}/include/glib-2.0"
          "-I${glib.out}/lib/glib-2.0/include"
          "-I${pango}/include/pango-1.0"
        ];
    };

    kfilemetadata = extendDerivation super.kfilemetadata {
      buildInputs = [ scope.attr ];
    };

    kwin = extendDerivation super.kwin {
      buildInputs = with scope.xorg; [ libICE libSM libXcursor ];
      patches = [ ./kwin/kwin-import-plugin-follow-symlinks.patch ];
    };

    libkscreen = extendDerivation super.libkscreen {
      buildInputs = [ scope.xorg.libXrandr];
    };

    plasma-desktop = extendDerivation super.plasma-desktop {
      buildInputs = with scope;
        [ canberra ]
        ++ (with xorg; [ libxkbfile libXcursor libXft ]);
      patches = [
        (scope.substituteAll {
          src = ./plasma-desktop/plasma-desktop-hwclock.patch;
          hwclock = "${scope.utillinux}/sbin/hwclock";
        })
        ./plasma-desktop/plasma-desktop-zoneinfo.patch
        (scope.substituteAll {
          src = ./plasma-desktop/plasma-desktop-xkb-rules.patch;
          xkb = scope.xkeyboard_config;
        })
      ];
      NIX_CFLAGS_COMPILE = with scope.xorg;
        lib.concatStringsSep " " [
          "-I${xf86inputsynaptics}/include/xorg"
          "-I${xf86inputevdev}/include/xorg"
          "-I${xorgserver}/include/xorg"
        ];
      cmakeFlags = with scope.xorg; [
        "-DEvdev_INCLUDE_DIRS=${xf86inputevdev}/include"
        "-DSynaptics_INCLUDE_DIRS=${xf86inputsynaptics}/include"
      ];
    };

    plasma-workspace = extendDerivation super.plasma-workspace {
      patches = [ ./plasma-workspace/0001-startkde-NixOS-patches.patch ];
      buildInputs = with scope.xorg; [ libSM libXcursor scope.pam ];

      inherit (scope) bash coreutils gnused gnugrep socat;
      inherit (scope) kconfig kinit kservice qt5tools;
      inherit (scope.xorg) mkfontdir xmessage xprop xrdb xset xsetroot;
      dbus_tools = scope.dbus.tools;
      kde_workspace = kdeApps.kde-workspace;
      postPatch = ''
        substituteInPlace startkde/kstartupconfig/kstartupconfig.cpp \
          --replace kdostartupconfig5 $out/bin/kdostartupconfig5
        substituteAllInPlace startkde/startkde.cmake
      '';
    };

    powerdevil = extendDerivation super.powerdevil {
      buildInputs = [ scope.xorg.libXrandr ];
    };

    sddm-kcm = extendDerivation super.sddm-kcm {
      buildInputs = [ scope.xorg.libXcursor ];
    };

  };

in self
