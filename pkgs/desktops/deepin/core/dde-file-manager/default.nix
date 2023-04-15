{ stdenv
, lib
, fetchFromGitHub
, fetchpatch
, runtimeShell
, dtkwidget
, qt5integration
, qt5platform-plugins
, dde-qt-dbus-factory
, docparser
, dde-dock
, deepin-movie-reborn
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
  version = "6.0.13";

  src = fetchFromGitHub {
    owner = "linuxdeepin";
    repo = pname;
    rev = version;
    sha256 = "sha256-Kn8LuAQNWY2SwzKjMyylEAlQNxsP+3bl5hM83yHfjvo=";
  };

  nativeBuildInputs = [
    cmake
    qttools
    pkg-config
    wrapQtAppsHook
    wrapGAppsHook
  ];
  dontWrapGApps = true;

  patches = [
    (fetchpatch {
      name = "chore-cmake-use_CMAKE_INSTALL_SYSCONFDIR.patch";
      url = "https://github.com/linuxdeepin/dde-file-manager/commit/b3b6b1e5ace0fdd86d0a94687a4e60e7bdfb1086.patch";
      sha256 = "sha256-GEMuMa1UMSGf0dlHZRQyR1hC08U0GlAlmUKLIxzzoc4=";
    })
    (fetchpatch {
      name = "feat-GRANDSEARCHDAEMON_LIB_DIR-use-CMAKE_INSTALL_FULL_LIBDIR.patch";
      url = "https://github.com/linuxdeepin/dde-file-manager/commit/58e3826fc4ad46145b57c2b6f8ca2c74efd8d4d3.patch";
      sha256 = "sha256-athDoFhQ9v9cXOf4YKmZld1RScX43+6/q1zBa/1yAgQ=";
    })
    (fetchpatch {
      name = "fix-include-path-should-follow-Qt5Widgets_PRIVATE_INCLUDE_DIRS.patch";
      url = "https://github.com/linuxdeepin/dde-file-manager/commit/19fdfffc6ddba2844176ee8384e4147bebee9be4.patch";
      sha256 = "sha256-VPyiKKxFgNsY70ZdYE5oNF8BFosq/92YrZuZ882Fj4E=";
    })
    (fetchpatch {
      name = "chore-do-not-hardcode-APPSHAREDIR.patch";
      url = "https://github.com/linuxdeepin/dde-file-manager/commit/74f5cbda8114e24259b6fd998ade794e7880c725.patch";
      sha256 = "sha256-oZQcuPP9JTZ7aybPnmY/6RyqmJhvpxer4mhv+XpqeQY=";
    })
    (fetchpatch {
      name = "fix-use-pkgconfig-to-check-mount.patch";
      url = "https://github.com/linuxdeepin/dde-file-manager/commit/4d5be539ba2c567bee1ec4aad90ecda0b87878d5.patch";
      sha256 = "sha256-k808IsaV/RJg7bYNmUnhcFZMnMRQ8sGRagMlx5i4h4Q=";
    })
  ];

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
    qt5integration
    deepin-pdfium
    util-dfm
    dde-qt-dbus-factory
    glibmm
    docparser
    dde-dock
    deepin-movie-reborn
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

