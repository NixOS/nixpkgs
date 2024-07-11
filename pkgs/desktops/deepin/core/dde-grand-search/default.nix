{ stdenv
, lib
, fetchFromGitHub
, cmake
, qttools
, pkg-config
, wrapQtAppsHook
, dtkwidget
, dde-qt-dbus-factory
, dde-dock
, deepin-pdfium
, qt5integration
, qt5platform-plugins
, taglib
, ffmpeg
, ffmpegthumbnailer
, pcre
, dbus
}:

stdenv.mkDerivation rec {
  pname = "dde-grand-search";
  version = "5.4.9";

  src = fetchFromGitHub {
    owner = "linuxdeepin";
    repo = pname;
    rev = version;
    hash = "sha256-WybwV1QIuV7O1SSgQU1ABsMf5QW9KJ95YyIa8Tz8pJ0=";
  };

  nativeBuildInputs = [
    cmake
    qttools
    pkg-config
    wrapQtAppsHook
  ];

  buildInputs = [
    dtkwidget
    dde-dock
    dde-qt-dbus-factory
    deepin-pdfium
    qt5integration
    qt5platform-plugins
    taglib
    ffmpeg
    ffmpegthumbnailer
    pcre
  ];

  patches = [
    # This patch revert the commit e6735e7
    # FIXME: why StartManager can't work, is dde-api-proxy still required?
    ./fix-dbus-path-for-daemon.diff
    ./patch-check-v23-interface.diff
  ];

  postPatch = ''
    # fix access permit to daemon
    substituteInPlace src/libgrand-search-daemon/dbusservice/grandsearchinterface.cpp \
      --replace-fail "/usr/bin/dde-grand-search" "$out/bin/.dde-grand-search-wrapped"

    for file in $(grep -rl "/usr/bin/dde-grand-search"); do
      substituteInPlace $file --replace-fail "/usr/bin/dde-grand-search" "$out/bin/dde-grand-search"
    done

    substituteAllInPlace src/grand-search-daemon/data/com.deepin.dde.daemon.GrandSearch.service
  '';

  cmakeFlags = [
    "-DVERSION=${version}"
    "-DNIX_DEEPIN_VERSION=23"
  ];

  meta = {
    description = "System-wide desktop search for DDE";
    homepage = "https://github.com/linuxdeepin/dde-grand-search";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.linux;
    maintainers = lib.teams.deepin.members;
  };
}
