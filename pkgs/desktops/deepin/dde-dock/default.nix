{ stdenv, mkDerivation, fetchFromGitHub, cmake, pkgconfig, qttools, qtx11extras,
  qtsvg, polkit, gsettings-qt, dtkcore, dtkwidget,
  dde-qt-dbus-factory, dde-network-utils, dde-daemon,
  deepin-desktop-schemas, xorg, glib, wrapGAppsHook, deepin,
  plugins ? [], symlinkJoin, makeWrapper, libdbusmenu }:

let
unwrapped = mkDerivation rec {
  pname = "dde-dock";
  version = "4.10.3";

  src = fetchFromGitHub {
    owner = "linuxdeepin";
    repo = pname;
    rev = version;
    sha256 = "17iy78r0frpv42g521igfdcgdklbifzig1wzxq2nl14fq0bgxg4v";
  };

  nativeBuildInputs = [
    cmake
    pkgconfig
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
    dtkwidget
    glib.bin
    gsettings-qt
    libdbusmenu
    polkit
    qtsvg
    qtx11extras
    xorg.libXdmcp
    xorg.libXtst
    xorg.libpthreadstubs
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
    fixPath ${dde-daemon}        /usr/lib/deepin-daemon       frame/item/showdesktopitem.cpp
    fixPath ${dde-network-utils} /usr/share/dde-network-utils frame/main.cpp
    fixPath ${polkit}            /usr/bin/pkexec              plugins/overlay-warning/overlay-warning-plugin.cpp

    substituteInPlace frame/controller/dockpluginscontroller.cpp --subst-var-by out $out
    substituteInPlace plugins/tray/system-trays/systemtrayscontroller.cpp --subst-var-by out $out
  '';

  cmakeFlags = [ "-DDOCK_TRAY_USE_NATIVE_POPUP=YES" ];

  postFixup = ''
    searchHardCodedPaths $out
  '';

  passthru.updateScript = deepin.updateScript { inherit ;name = "${pname}-${version}"; };

  meta = with stdenv.lib; {
    description = "Dock for Deepin Desktop Environment";
    homepage = https://github.com/linuxdeepin/dde-dock;
    license = licenses.gpl3;
    platforms = platforms.linux;
    maintainers = with maintainers; [ romildo ];
  };
};

in if plugins == [] then unwrapped
    else import ./wrapper.nix {
      inherit makeWrapper symlinkJoin plugins;
      dde-dock = unwrapped;
    }
