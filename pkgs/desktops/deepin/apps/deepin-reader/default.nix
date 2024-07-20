{ stdenv
, lib
, fetchFromGitHub
, qmake
, pkg-config
, qttools
, wrapQtAppsHook
, dtkwidget
, qt5integration
, qt5platform-plugins
, dde-qt-dbus-factory
, qtwebengine
, karchive
, poppler
, libchardet
, libspectre
, openjpeg
, djvulibre
, qtbase
, gtest
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
    qmake
    pkg-config
    qttools
    wrapQtAppsHook
  ];

  buildInputs = [
    dtkwidget
    qt5integration
    qt5platform-plugins
    dde-qt-dbus-factory
    qtwebengine
    karchive
    poppler
    libchardet
    libspectre
    djvulibre
    openjpeg
    gtest
  ];

  qmakeFlags = [
    "DEFINES+=VERSION=${version}"
  ];

  meta = with lib; {
    description = "Simple memo software with texts and voice recordings";
    mainProgram = "deepin-reader";
    homepage = "https://github.com/linuxdeepin/deepin-reader";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = teams.deepin.members;
  };
}
