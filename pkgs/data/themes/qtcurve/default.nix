{ stdenv, fetchFromGitHub, cmake, extra-cmake-modules, pkgconfig, mkDerivation
, gtk2, qtbase, qtsvg, qtx11extras # Toolkit dependencies
, karchive, kconfig, kconfigwidgets, kio, frameworkintegration
, kguiaddons, ki18n, kwindowsystem, kdelibs4support, kiconthemes
, libpthreadstubs, pcre, libXdmcp, libX11, libXau # X11 dependencies
, fetchpatch
}:

let
  version = "1.9.1";
in mkDerivation {
  pname = "qtcurve";
  inherit version;
  src = fetchFromGitHub {
    owner = "KDE";
    repo = "qtcurve";
    rev = version;
    sha256 = "0sm1fza68mwl9cvid4h2lsyxq5svia86l5v9wqk268lmx16mbzsw";
  };

  patches = [
    (fetchpatch {
      url = "https://github.com/KDE/qtcurve/commit/ee2228ea2f18ac5da9b434ee6089381df815aa94.patch";
      sha256 = "1vz5frsrsps93awn84gk8d7injrqfcyhc1rji6s0gsgsp5z9sl34";
    })
  ];

  enableParallelBuilding = true;

  nativeBuildInputs = [ cmake extra-cmake-modules pkgconfig ];

  buildInputs = [
    gtk2
    qtbase qtsvg qtx11extras
    karchive kconfig kconfigwidgets kio kiconthemes kguiaddons ki18n
    kwindowsystem kdelibs4support frameworkintegration
    libpthreadstubs
    pcre
    libXdmcp libX11 libXau
  ];

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

  meta = with stdenv.lib; {
    homepage = https://github.com/QtCurve/qtcurve;
    description = "Widget styles for Qt5/Plasma 5 and gtk2";
    platforms = platforms.linux;
    license = licenses.lgpl21Plus;
    maintainers = [ maintainers.gnidorah ];
  };
}
