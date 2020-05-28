{ stdenv
, mkDerivation
, fetchFromGitHub
, cmake
, pkg-config
, dde-daemon
, dde-network-utils
, dde-qt-dbus-factory
, deepin
, deepin-desktop-schemas
, dtkcore
, dtkgui
, dtkwidget
, glib
, gsettings-qt
, libdbusmenu
, makeWrapper
, plugins ? [ ]
, polkit
, qtsvg
, qttools
, qtx11extras
, symlinkJoin
, wrapGAppsHook
, xorg
}:

let
  unwrapped = mkDerivation rec {
    pname = "dde-dock";
    version = "5.1.0.11";

    src = fetchFromGitHub {
      owner = "linuxdeepin";
      repo = pname;
      rev = version;
      sha256 = "0ksrilmjypm5b069ra51i0dwr818h6ddsnhp9h5h47mpwg74kx7c";
    };

    nativeBuildInputs = [
      cmake
      pkg-config
      qttools
      wrapGAppsHook
      deepin.setupHook
    ];

    buildInputs = [
      dde-daemon
      dde-network-utils
      dde-qt-dbus-factory
      deepin-desktop-schemas
      dtkcore
      dtkgui
      dtkwidget
      glib
      gsettings-qt
      libdbusmenu
      polkit
      qtsvg
      qtx11extras
      xorg.libXtst
    ];

    patches = [
      ./dde-dock.plugins-dir.patch
    ];

    postPatch = ''
      searchHardCodedPaths
      patchShebangs translate_generation.sh
      fixPath $out                 /etc/dde-dock                plugins/keyboard-layout/CMakeLists.txt
      fixPath $out                 /usr                         cmake/DdeDock/DdeDockConfig.cmake
      fixPath $out                 /usr                         dde-dock.pc
      fixPath $out                 /usr/bin/dde-dock            frame/com.deepin.dde.Dock.service
      fixPath $out                 /usr/share/dbus-1            CMakeLists.txt
      fixPath ${dde-daemon}        /usr/lib/deepin-daemon       plugins/show-desktop/showdesktopplugin.cpp
      fixPath ${dde-daemon}        /usr/lib/deepin-daemon       frame/panel/mainpanelcontrol.cpp
      fixPath ${dde-network-utils} /usr/share/dde-network-utils frame/main.cpp
      fixPath ${polkit}            /usr/bin/pkexec              plugins/overlay-warning/overlay-warning-plugin.cpp

      substituteInPlace frame/controller/dockpluginscontroller.cpp --subst-var-by out $out
      substituteInPlace plugins/tray/system-trays/systemtrayscontroller.cpp --subst-var-by out $out
    '';

    cmakeFlags = [ "-DDOCK_TRAY_USE_NATIVE_POPUP=YES" ];

    dontWrapQtApps = true;

    preFixup = ''
      glib-compile-schemas ${glib.makeSchemaPath "$out" "${pname}-${version}"}

      gappsWrapperArgs+=(
        "''${qtWrapperArgs[@]}"
      )
    '';

    postFixup = ''
      searchHardCodedPaths $out
    '';

    passthru.updateScript = deepin.updateScript { inherit pname version src; };

    meta = with stdenv.lib; {
      description = "Dock for Deepin Desktop Environment";
      homepage = "https://github.com/linuxdeepin/dde-dock";
      license = licenses.gpl3;
      platforms = platforms.linux;
      maintainers = with maintainers; [ romildo ];
    };
  };

in
if plugins == [ ]
then unwrapped
else import ./wrapper.nix {
  inherit makeWrapper symlinkJoin plugins;
  dde-dock = unwrapped;
}
