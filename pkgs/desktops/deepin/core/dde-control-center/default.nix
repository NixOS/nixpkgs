{ stdenv
, lib
, fetchFromGitHub
, dtkwidget
, qt5integration
, qt5platform-plugins
, dde-qt-dbus-factory
, deepin-pw-check
, udisks2-qt5
, cmake
, qttools
, qtbase
, pkg-config
, qtx11extras
, qtmultimedia
, wrapQtAppsHook
, wrapGAppsHook
, gsettings-qt
, wayland
, kwayland
, qtwayland
, polkit-qt
, pcre
, xorg
, libselinux
, libsepol
, libxcrypt
, librsvg
, networkmanager-qt
, glib
, runtimeShell
, tzdata
, dbus
, gtest
}:

stdenv.mkDerivation rec {
  pname = "dde-control-center";
  version = "5.6.3";

  src = fetchFromGitHub {
    owner = "linuxdeepin";
    repo = pname;
    rev = version;
    sha256 = "sha256-/gzS+IbopIDRpufsa9cEfFBOqehPUnF4IozvwW8UEbY=";
  };

  patches = [
    # UserExperienceProgramLicenseAgreement comes from a non-open source component(deepin-deepinid-client)
    # If we don't block it, only an empty page will be displayed here
    # Remove this patch when dde-control-center is upgraded to 6.0.0
    ./dont-show-endUserLicenseAgreement-for-deepinos.patch
  ];

  postPatch = ''
    substituteInPlace src/frame/window/{mainwindow.cpp,insertplugin.cpp} com.deepin.controlcenter.develop.policy \
      --replace "/usr/lib/dde-control-center" "/run/current-system/sw/lib/dde-control-center"

    substituteInPlace src/frame/modules/datetime/timezone_dialog/timezone.cpp \
      --replace "/usr/share/zoneinfo" "${tzdata}/share/zoneinfo"

    substituteInPlace src/frame/modules/accounts/accountsworker.cpp \
      --replace "/bin/bash" "${runtimeShell}"

    substituteInPlace dde-control-center-autostart.desktop \
      --replace "/usr" "$out"

    substituteInPlace com.deepin.dde.ControlCenter.service \
      --replace "/usr/bin/dbus-send" "${dbus}/bin/dbus-send" \
      --replace "/usr/share" "$out/share"

    substituteInPlace include/widgets/utils.h src/{reboot-reminder-dialog/main.cpp,frame/main.cpp,reset-password-dialog/main.cpp} \
      --replace "/usr/share/dde-control-center" "$out/share/dde-control-center"

    substituteInPlace dde-control-center-wapper \
      --replace "qdbus" "${qttools.bin}/bin/qdbus" \
      --replace "/usr/share" "$out/share"
  '';

  nativeBuildInputs = [
    cmake
    qttools
    pkg-config
    wrapQtAppsHook
    wrapGAppsHook
  ];
  dontWrapGApps = true;

  buildInputs = [
    dtkwidget
    qt5platform-plugins
    dde-qt-dbus-factory
    deepin-pw-check
    qtbase
    qtx11extras
    qtmultimedia
    gsettings-qt
    udisks2-qt5
    wayland
    kwayland
    qtwayland
    polkit-qt
    pcre
    xorg.libXdmcp
    libselinux
    libsepol
    libxcrypt
    librsvg
    networkmanager-qt
    gtest
  ];

  cmakeFlags = [
    "-DCVERSION=${version}"
    "-DDISABLE_AUTHENTICATION=YES"
    "-DDISABLE_ACTIVATOR=YES"
    "-DDISABLE_SYS_UPDATE=YES"
    "-DDISABLE_RECOVERY=YES"
  ];

  # qt5integration must be placed before qtsvg in QT_PLUGIN_PATH
  qtWrapperArgs = [
    "--prefix QT_PLUGIN_PATH : ${qt5integration}/${qtbase.qtPluginPrefix}"
    "--prefix LD_LIBRARY_PATH : ${lib.makeLibraryPath [ librsvg ]}"
  ];

  preFixup = ''
    glib-compile-schemas ${glib.makeSchemaPath "$out" "${pname}-${version}"}
    qtWrapperArgs+=("''${gappsWrapperArgs[@]}")
  '';

  meta = with lib; {
    description = "Control panel of Deepin Desktop Environment";
    homepage = "https://github.com/linuxdeepin/dde-control-center";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = teams.deepin.members;
  };
}
