{ stdenv
, lib
, fetchFromGitHub
, runtimeShell
, dtkwidget
, qt5integration
, qt5platform-plugins
, dde-qt-dbus-factory
, docparser
, dde-dock
, cmake
, qttools
, qtx11extras
, qtmultimedia
, kcodecs
, pkg-config
, ffmpegthumbnailer
, libsecret
, libmediainfo
, mediainfo
, libzen
, poppler
, polkit-qt
, polkit
, wrapQtAppsHook
, wrapGAppsHook
, lucenepp
, boost
, taglib
, cryptsetup
, glib
, qtbase
, util-dfm
, deepin-pdfium
, libuuid
, libselinux
, glibmm
, pcre
, udisks2
, libisoburn
}:

stdenv.mkDerivation rec {
  pname = "dde-file-manager";
  version = "6.0.23";

  src = fetchFromGitHub {
    owner = "linuxdeepin";
    repo = pname;
    rev = version;
    hash = "sha256-H+pCWZ1jj5p3gOKXYyLxSmjCMv5/BPIz5A25JGGzrR8=";
  };

  nativeBuildInputs = [
    cmake
    qttools
    pkg-config
    wrapQtAppsHook
    wrapGAppsHook
  ];
  dontWrapGApps = true;

  postPatch = ''
    patchShebangs .

    substituteInPlace src/plugins/filemanager/dfmplugin-vault/utils/vaultdefine.h \
      --replace "/usr/bin/deepin-compressor" "deepin-compressor"

    substituteInPlace src/plugins/filemanager/dfmplugin-avfsbrowser/utils/avfsutils.cpp \
      --replace "/usr/bin/mountavfs" "mountavfs" \
      --replace "/usr/bin/umountavfs" "umountavfs"

    substituteInPlace src/plugins/common/core/dfmplugin-menu/{extendmenuscene/extendmenu/dcustomactionparser.cpp,oemmenuscene/oemmenu.cpp} \
      --replace "/usr" "$out"

    substituteInPlace src/tools/upgrade/dialog/processdialog.cpp \
      --replace "/usr/bin/dde-file-manager" "dde-file-manager" \
      --replace "/usr/bin/dde-desktop" "dde-desktop"

    substituteInPlace src/dfm-base/file/local/localfilehandler.cpp \
      --replace "/usr/lib/deepin-daemon" "/run/current-system/sw/lib/deepin-daemon"

    substituteInPlace src/plugins/desktop/ddplugin-background/backgroundservice.cpp \
      src/plugins/desktop/ddplugin-wallpapersetting/wallpapersettings.cpp \
      --replace "/usr/share/backgrounds" "/run/current-system/sw/share/backgrounds"

    find . -type f -regex ".*\\.\\(service\\|policy\\|desktop\\)" -exec sed -i -e "s|/usr/|$out/|g" {} \;
  '';

  buildInputs = [
    dtkwidget
    qt5platform-plugins
    deepin-pdfium
    util-dfm
    dde-qt-dbus-factory
    glibmm
    docparser
    dde-dock
    qtx11extras
    qtmultimedia
    kcodecs
    ffmpegthumbnailer
    libsecret
    libmediainfo
    mediainfo
    poppler
    polkit-qt
    polkit
    lucenepp
    boost
    taglib
    cryptsetup
    libuuid
    libselinux
    pcre
    udisks2
    libisoburn
  ];

  cmakeFlags = [
    "-DVERSION=${version}"
    "-DDEEPIN_OS_VERSION=20"
  ];

  enableParallelBuilding = true;

  # qt5integration must be placed before qtsvg in QT_PLUGIN_PATH
  qtWrapperArgs = [
    "--prefix QT_PLUGIN_PATH : ${qt5integration}/${qtbase.qtPluginPrefix}"
  ];

  preFixup = ''
    qtWrapperArgs+=("''${gappsWrapperArgs[@]}")
  '';

  meta = with lib; {
    description = "File manager for deepin desktop environment";
    homepage = "https://github.com/linuxdeepin/dde-file-manager";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = teams.deepin.members;
  };
}

