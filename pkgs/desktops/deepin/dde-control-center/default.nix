{ stdenv
, mkDerivation
, fetchFromGitHub
, fetchpatch
, pkg-config
, cmake
, deepin
, qttools
, qtdeclarative
, networkmanager
, qtsvg
, qtx11extras
, dtkwidget
, geoip
, gsettings-qt
, dde-network-utils
, networkmanager-qt
, xorg
, mtdev
, fontconfig
, freetype
, dde-api
, dde-daemon
, qt5integration
, deepin-desktop-base
, deepin-desktop-schemas
, systemd
, dde-qt-dbus-factory
, qtmultimedia
, qtbase
, glib
, gnome3
, substituteAll
, tzdata
, udisks2-qt5
, libpwquality
, wrapGAppsHook
}:

mkDerivation rec {
  pname = "dde-control-center";
  version = "5.3.0.9";

  src = fetchFromGitHub {
    owner = "linuxdeepin";
    repo = pname;
    rev = version;
    sha256 = "19ahksgs4zjqg1g51rpfl8d9y27pdvjmwwbq4z9g7h3f3jl959c8";
  };

  nativeBuildInputs = [
    cmake
    deepin.setupHook
    pkg-config
    wrapGAppsHook
  ];

  buildInputs = [
    dde-api
    dde-daemon
    dde-network-utils
    dde-qt-dbus-factory
    deepin-desktop-base
    deepin-desktop-schemas
    dtkwidget
    fontconfig
    freetype
    geoip
    glib
    gnome3.networkmanager-l2tp
    gnome3.networkmanager-openconnect
    gnome3.networkmanager-openvpn
    gnome3.networkmanager-vpnc
    gsettings-qt
    libpwquality
    mtdev
    networkmanager-qt
    qt5integration
    qtbase
    qtdeclarative
    qtmultimedia
    qtsvg
    qttools
    qtx11extras
    udisks2-qt5
    xorg.libX11
    xorg.libXext
    xorg.libXrandr
    xorg.libxcb
  ];

  cmakeFlags = [
    "-DDISABLE_SYS_UPDATE=YES"
    "-DDCC_DISABLE_GRUB=YES"
  ];

  patches = [
    (fetchpatch {
      url = "https://raw.githubusercontent.com/archlinux/svntogit-community/packages/deepin-control-center/trunk/deepin-control-center-no-user-experience.patch";
      sha256 = "0n4kzk7vc5hai4fi9wga64756y4zms9hy504bddasvqsg8sw0mw7";
    })
    # (fetchpatch {
    #   name = "deepin-control-center-build-fix.patch";
    #   url = "https://git.archlinux.org/svntogit/community.git/plain/trunk/deepin-control-center-build-fix.patch?h=packages/deepin-control-center";
    #   sha256 = "09k0vlwwg9zsqhp1y0miagch39hf8s0r2yi98p11gjydkh8nm1cz";
    # })
    (substituteAll {
      src = ./fix-paths.patch;
      nmcli = "${networkmanager}/bin/nmcli";
      # not packaged
      # dman = "${deepin-manual}/bin/dman";
      inherit tzdata;
      # exclusive to deepin linux?
      # allows to synchronize configuration files to cloud networks
      # deepin_sync = "${deepin-sync}";
    })
  ];

  postPatch = ''
    searchHardCodedPaths

    patchShebangs translate_ts2desktop.sh
    patchShebangs translate_generation.sh
    patchShebangs translate_desktop2ts.sh

    fixPath $out /usr \
      abrecovery/deepin-ab-recovery.desktop \
      com.deepin.dde.ControlCenter.service \
      dde-control-center-autostart.desktop \
      include/widgets/utils.h \
      src/frame/window/mainwindow.cpp

    fixPath ${tzdata} /usr/share/zoneinfo \
      src/frame/modules/datetime/timezone_dialog/timezone.cpp

    fixPath ${dde-network-utils} /usr/share/dde-network-utils \
      src/frame/main.cpp

    fixPath $out /usr/share/dde-control-center/translations \
      abrecovery/main.cpp \
      src/dialogs/main.cpp

    substituteInPlace abrecovery/CMakeLists.txt \
      --replace "DESTINATION /usr/bin" "DESTINATION $out/bin" \
      --replace "DESTINATION /etc/xdg" "DESTINATION $out/etc/xdg"

    substituteInPlace com.deepin.controlcenter.addomain.policy \
      --replace "/bin/systemctl" "/run/current-system/sw/bin/systemctl"

    substituteInPlace dde-control-center.desktop \
      --replace Exec=dde-control-center Exec=$out/bin/dde-control-center

    # remove after they obey -DDISABLE_SYS_UPDATE properly
    sed -i '/new UpdateModule/d' src/frame/window/mainwindow.cpp
  '';

  postInstall = ''
    rm $out/etc/xdg/autostart/deepin-ab-recovery.desktop
    rmdir $out/etc/xdg/autostart $out/etc/xdg $out/etc
  '';

  dontWrapQtApps = true;

  preFixup = ''
    gappsWrapperArgs+=(
      "''${qtWrapperArgs[@]}"
    )
  '';

  postFixup = ''
    # debuging
    searchForUnresolvedDLL $out
    searchHardCodedPaths $out
  '';

  passthru.updateScript = deepin.updateScript { inherit pname version src; };

  meta = with stdenv.lib; {
    description = "Control panel of Deepin Desktop Environment";
    homepage = "https://github.com/linuxdeepin/dde-control-center";
    license = licenses.gpl3;
    platforms = platforms.linux;
    maintainers = with maintainers; [ romildo worldofpeace ];
  };
}
