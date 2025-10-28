{
  lib,
  fetchFromGitHub,
  cmake,
  extra-cmake-modules,
  pkg-config,
  mkDerivation,
  gtk2Support ? true,
  gtk2,
  qtbase,
  qtsvg,
  qtx11extras, # Toolkit dependencies
  karchive,
  kconfig,
  kconfigwidgets,
  kio,
  frameworkintegration,
  kguiaddons,
  ki18n,
  kwindowsystem,
  kdelibs4support,
  kiconthemes,
  libpthreadstubs,
  pcre,
  libXdmcp,
  libX11,
  libXau, # X11 dependencies
  fetchpatch,
}:

mkDerivation rec {
  pname = "qtcurve";
  version = "1.9.1";
  src = fetchFromGitHub {
    owner = "KDE";
    repo = "qtcurve";
    rev = version;
    sha256 = "XP9VTeiVIiMm5mkXapCKWxfcvaYCkhY3S5RXZNR3oWo=";
  };

  patches = [
    # Fix build with CMake 4
    (fetchpatch {
      url = "https://github.com/KDE/qtcurve/commit/d2c84577505641e647fbb64bce825b3e0a4129f5.patch";
      sha256 = "sha256-WBmzlVDxRNXZmi6c03cR1MuIr+hBaeFXgNLzhsv0bZo=";
    })
    # Remove unnecessary constexpr, this is not allowed in C++14
    (fetchpatch {
      url = "https://github.com/KDE/qtcurve/commit/ee2228ea2f18ac5da9b434ee6089381df815aa94.patch";
      sha256 = "1vz5frsrsps93awn84gk8d7injrqfcyhc1rji6s0gsgsp5z9sl34";
    })
    # Fix build with Qt5.15
    (fetchpatch {
      url = "https://github.com/KDE/qtcurve/commit/44e2a35ebb164dcab0bad1a9158b1219a3ff6504.patch";
      sha256 = "5I2fTxKRJX0cJcyUvYHWZx369FKk6ti9Se7AfYmB9ek=";
    })
  ];

  nativeBuildInputs = [
    cmake
    extra-cmake-modules
    pkg-config
  ];

  buildInputs = [
    qtbase
    qtsvg
    qtx11extras
    karchive
    kconfig
    kconfigwidgets
    kio
    kiconthemes
    kguiaddons
    ki18n
    kwindowsystem
    kdelibs4support
    frameworkintegration
    libpthreadstubs
    pcre
    libXdmcp
    libX11
    libXau
  ]
  ++ lib.optional gtk2Support gtk2;

  preConfigure = ''
    for i in qt5/CMakeLists.txt qt5/config/CMakeLists.txt
    do
      substituteInPlace $i \
        --replace "{_Qt5_PLUGIN_INSTALL_DIR}" "{KDE_INSTALL_QTPLUGINDIR}"
    done
    substituteInPlace CMakeLists.txt \
      --replace \$\{GTK2_PREFIX\} $out
    substituteInPlace gtk2/style/CMakeLists.txt \
      --replace \$\{GTK2_LIBDIR\} $out/lib
    patchShebangs tools/gen-version.sh
  '';

  configureFlags = [
    "-DENABLE_GTK2=${if gtk2Support then "ON" else "OFF"}"
    "-DENABLE_QT4=OFF"
  ];

  meta = with lib; {
    homepage = "https://github.com/QtCurve/qtcurve";
    description = "Widget styles for Qt5/Plasma 5 and gtk2";
    platforms = platforms.linux;
    license = licenses.lgpl21Plus;
    maintainers = [ ];
  };
}
