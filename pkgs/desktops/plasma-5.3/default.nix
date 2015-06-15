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

{ pkgs, newScope, kf5 ? null, qt5 ? null, debug ? false }:

let inherit (pkgs) autonix stdenv symlinkJoin; in

let kf5Orig = kf5; in

let
  kf5_ = if kf5 != null then kf5 else pkgs.kf510;
  qt5_ = if qt5 != null then qt5 else pkgs.qt54;
in

let

  qt5 = qt5_;
  kf5 = kf5_.override { inherit qt5; };

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
      qt5script = qt5.script;
      qt5tools = qt5.tools;
      qt5x11extras = qt5.x11extras;
    } //
    # packages from nixpkgs
    (with pkgs; {
      inherit attr bash cairo cmake dbus epoxy exiv2 ffmpeg freetype
              glib gnugrep gnused gtk2 gtk3 libinput libssh
              modemmanager openconnect openexr pam pango qt4 samba
              socat substituteAll taglib utillinux wayland xapian
              xkeyboard_config xlibs xorg;
      boost = boost155;
      canberra = libcanberra;
      epub = ebook_tools;
      fontforge_executable = fontforge;
      mobilebroadbandproviderinfo = mobile_broadband_provider_info;
      mtp = libmtp;
      pulseaudio = libpulseaudio;
      shareddesktopontologies = shared_desktop_ontologies;
      sharedmimeinfo = shared_mime_info;
      usb = libusb;
    });

  self = (builtins.removeAttrs super ["bluedevil"]) // {

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
          buildInputs = [ pkgs.xlibs.xproto pkgs.kde4.kdelibs pkgs.qt4 ];
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

    kde-gtk-config = overrideDerivation super.kde-gtk-config (drv: {
      NIX_CFLAGS_COMPILE = with scope;
        lib.concatStringsSep " " [
          "-I${cairo}/include/cairo"
          "-I${gtk2}/include/gtk-2.0"
          "-I${gtk2}/lib/gtk-2.0/include"
          "-I${glib}/include/glib-2.0"
          "-I${glib}/lib/glib-2.0/include"
          "-I${pango}/include/pango-1.0"
        ];
    });

    kfilemetadata = overrideDerivation super.kfilemetadata (drv: {
      buildInputs = drv.buildInputs ++ [ pkgs.attr ];
    });

    kwin = overrideDerivation super.kwin (drv: {
      buildInputs =
        drv.buildInputs ++ (with pkgs.xlibs; [ libICE libSM libXcursor ]);
      patches = [ ./kwin/kwin-import-plugin-follow-symlinks.patch ];
    });

    libkscreen = overrideDerivation super.libkscreen (drv: {
      buildInputs = drv.buildInputs ++ [ pkgs.xlibs.libXrandr];
    });

    plasma-desktop = overrideDerivation super.plasma-desktop (drv: {
      buildInputs =
        drv.buildInputs
        ++ [ pkgs.libcanberra ]
        ++ (with pkgs.xlibs; [ libxkbfile libXcursor libXft ]);
      patches = [
        ./plasma-desktop/plasma-desktop-hwclock.patch
        ./plasma-desktop/plasma-desktop-zoneinfo.patch
        (pkgs.substituteAll {
          src = ./plasma-desktop/plasma-desktop-xkb-rules.patch;
          xkb = pkgs.xkeyboard_config;
        })
      ];
      preConfigure = ''
        substituteInPlace kcms/dateandtime/helper.cpp \
          --subst-var-by hwclock "${scope.utillinux}/sbin/hwclock"
      '';
    });

    plasma-workspace = overrideDerivation super.plasma-workspace (drv: {
      patches = [
        (pkgs.substituteAll {
          src = ./plasma-workspace/0001-startkde-NixOS-patches.patch;
          inherit (pkgs) bash gnused gnugrep socat;
          inherit (kf5) kconfig kinit kservice;
          inherit (pkgs.xorg) mkfontdir xmessage xprop xrdb xset xsetroot;
          qt5tools = qt5.tools;
          dbus_tools = pkgs.dbus.tools;
        })
      ];
      buildInputs =
        (drv.buildInputs or [])
        ++ (with pkgs.xlibs; [ libSM libXcursor scope.pam ]);
      postPatch = ''
        substituteInPlace startkde/kstartupconfig/kstartupconfig.cpp \
          --replace kdostartupconfig5 $out/bin/kdostartupconfig5
      '';
      preConfigure = ''
        substituteInPlace startkde/startkde.cmake \
          --subst-var-by plasmaWorkspace "$out"
      '';
    });

    powerdevil = overrideDerivation super.powerdevil (drv: {
      buildInputs = drv.buildInputs ++ [pkgs.xlibs.libXrandr];
    });

    sddm-kcm = overrideDerivation super.sddm-kcm (drv: {
      buildInputs = drv.buildInputs ++ [pkgs.xlibs.libXcursor];
    });

  };

in self
