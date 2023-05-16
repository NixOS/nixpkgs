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
<<<<<<< HEAD
, gtest
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
}:

stdenv.mkDerivation rec {
  pname = "deepin-reader";
<<<<<<< HEAD
  version = "6.0.2";
=======
  version = "5.10.29";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "linuxdeepin";
    repo = pname;
    rev = version;
<<<<<<< HEAD
    hash = "sha256-69NCxa20wp/tyyGGH/FbHhZ83LECbJWAzaLRo7iYreA=";
  };

  # don't use vendored htmltopdf
  postPatch = ''
    substituteInPlace deepin_reader.pro \
      --replace "SUBDIRS += htmltopdf" " "
    substituteInPlace reader/document/Model.cpp \
      --replace "/usr/lib/deepin-reader/htmltopdf" "htmltopdf"
=======
    sha256 = "sha256-IpgmTmnrPWc9EFZVM+S2nFxdpPjbgXqEWUnK/O9FmUg=";
  };

  patches = [ ./use-pkg-config.diff ];

  postPatch = ''
    substituteInPlace reader/{reader.pro,document/Model.cpp} htmltopdf/htmltopdf.pro 3rdparty/deepin-pdfium/src/src.pro \
      --replace "/usr" "$out"
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
<<<<<<< HEAD
    gtest
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
