{
  stdenv,
  lib,
  fetchFromGitHub,
  fetchpatch,
  runtimeShell,
  dtkwidget,
  qt5integration,
  qt5platform-plugins,
  dde-qt-dbus-factory,
  docparser,
  dde-tray-loader,
  cmake,
  qttools,
  qtx11extras,
  qtmultimedia,
  kcodecs,
  pkg-config,
  ffmpegthumbnailer,
  libsecret,
  libmediainfo,
  mediainfo,
  libzen,
  poppler,
  polkit-qt,
  polkit,
  wrapQtAppsHook,
  wrapGAppsHook3,
  lucenepp,
  boost,
  taglib,
  cryptsetup,
  glib,
  qtbase,
  util-dfm,
  deepin-pdfium,
  libuuid,
  libselinux,
  glibmm,
  pcre,
  udisks2,
  libisoburn,
  gsettings-qt,
}:

stdenv.mkDerivation rec {
  pname = "dde-file-manager";
  version = "6.0.57";

  src = fetchFromGitHub {
    owner = "linuxdeepin";
    repo = pname;
    rev = version;
    hash = "sha256-laM6PgNdUNbsqbzKFGWk7DPuAWR+XHo0eXKG0CDuc9c=";
  };

  nativeBuildInputs = [
    cmake
    qttools
    pkg-config
    wrapQtAppsHook
    wrapGAppsHook3
  ];
  dontWrapGApps = true;

  patches = [
    ./patch_check_v23_interface.diff
    (fetchpatch {
      name = "fix-permission-to-execute-dde-file-manager.patch";
      url = "https://github.com/linuxdeepin/dde-file-manager/commit/b78cc4bd08dd487f67c5a332a2a2f4d20b3798c7.patch";
      hash = "sha256-Tw3iu6sU0rrsM78WGMBpBgvA9YdRTM1ObjCxyM928F4=";
    })
  ];

  postPatch = ''
    patchShebangs tests/*.sh \
                  assets/scripts \
                  src/*.sh \
                  src/plugins/daemon/daemonplugin-accesscontrol/help.sh \
                  src/apps/dde-file-manager/dde-property-dialog \
                  src/apps/dde-desktop/data/applications/dfm-open.sh

    substituteInPlace assets/scripts/file-manager.sh \
      --replace-fail "/usr/libexec/dde-file-manager" "$out/libexec/dde-file-manager"

    substituteInPlace src/plugins/filemanager/dfmplugin-vault/utils/vaultdefine.h \
      --replace-fail "/usr/bin/deepin-compressor" "deepin-compressor"

    substituteInPlace src/plugins/filemanager/dfmplugin-avfsbrowser/utils/avfsutils.cpp \
      --replace-fail "/usr/bin/mountavfs" "mountavfs" \
      --replace-fail "/usr/bin/umountavfs" "umountavfs"

    substituteInPlace src/plugins/common/core/dfmplugin-menu/{extendmenuscene/extendmenu/dcustomactionparser.cpp,oemmenuscene/oemmenu.cpp} \
      --replace-fail "/usr" "$out"

    substituteInPlace src/tools/upgrade/dialog/processdialog.cpp \
      --replace-fail "/usr/bin/dde-file-manager" "dde-file-manager" \
      --replace-fail "/usr/bin/dde-desktop" "dde-desktop"

    substituteInPlace src/dfm-base/file/local/localfilehandler.cpp \
      --replace-fail "/usr/lib/deepin-daemon" "/run/current-system/sw/lib/deepin-daemon"

    substituteInPlace src/plugins/desktop/ddplugin-background/backgroundservice.cpp \
      src/plugins/desktop/ddplugin-wallpapersetting/wallpapersettings.cpp \
      --replace-fail "/usr/share/backgrounds" "/run/current-system/sw/share/backgrounds"

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
    dde-tray-loader
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
    gsettings-qt
  ];

  cmakeFlags = [
    "-DVERSION=${version}"
    "-DNIX_DEEPIN_VERSION=23"
    "-DSYSTEMD_USER_UNIT_DIR=${placeholder "out"}/lib/systemd/user"
  ];

  enableParallelBuilding = true;

  # qt5integration must be placed before qtsvg in QT_PLUGIN_PATH
  qtWrapperArgs = [ "--prefix QT_PLUGIN_PATH : ${qt5integration}/${qtbase.qtPluginPrefix}" ];

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
