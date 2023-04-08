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
}:

stdenv.mkDerivation rec {
  pname = "deepin-reader";
  version = "5.10.29";

  src = fetchFromGitHub {
    owner = "linuxdeepin";
    repo = pname;
    rev = version;
    sha256 = "sha256-IpgmTmnrPWc9EFZVM+S2nFxdpPjbgXqEWUnK/O9FmUg=";
  };

  patches = [ ./use-pkg-config.diff ];

  postPatch = ''
    substituteInPlace reader/{reader.pro,document/Model.cpp} htmltopdf/htmltopdf.pro 3rdparty/deepin-pdfium/src/src.pro \
      --replace "/usr" "$out"
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
  ];

  qmakeFlags = [
    "DEFINES+=VERSION=${version}"
  ];

  meta = with lib; {
    description = "A simple memo software with texts and voice recordings";
    homepage = "https://github.com/linuxdeepin/deepin-reader";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = teams.deepin.members;
  };
}
