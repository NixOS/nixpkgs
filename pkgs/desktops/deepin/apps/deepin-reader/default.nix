{
  stdenv,
  lib,
  fetchFromGitHub,
  pkg-config,
  libsForQt5,
  dtkwidget,
  qt5integration,
  qt5platform-plugins,
  dde-qt-dbus-factory,
  poppler,
  libchardet,
  libspectre,
  openjpeg,
  djvulibre,
  gtest,
}:

stdenv.mkDerivation rec {
  pname = "deepin-reader";
  version = "6.0.5";

  src = fetchFromGitHub {
    owner = "linuxdeepin";
    repo = pname;
    rev = version;
    hash = "sha256-G5UZ8lBrUo5G3jMae70p/zi9kOVqHWMNCedOy45L1PA=";
  };

  patches = [ ./0001-build-tests-with-cpp-14.patch ];

  # don't use vendored htmltopdf
  postPatch = ''
    substituteInPlace deepin_reader.pro \
      --replace "SUBDIRS += htmltopdf" " "
    substituteInPlace reader/document/Model.cpp \
      --replace "/usr/lib/deepin-reader/htmltopdf" "htmltopdf"
  '';

  nativeBuildInputs = [
    libsForQt5.qmake
    pkg-config
    libsForQt5.qttools
    libsForQt5.wrapQtAppsHook
  ];

  buildInputs = [
    dtkwidget
    qt5integration
    qt5platform-plugins
    dde-qt-dbus-factory
    libsForQt5.qtwebengine
    libsForQt5.karchive
    poppler
    libchardet
    libspectre
    djvulibre
    openjpeg
    gtest
  ];

  qmakeFlags = [ "DEFINES+=VERSION=${version}" ];

  meta = with lib; {
    description = "Simple memo software with texts and voice recordings";
    mainProgram = "deepin-reader";
    homepage = "https://github.com/linuxdeepin/deepin-reader";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = teams.deepin.members;
  };
}
