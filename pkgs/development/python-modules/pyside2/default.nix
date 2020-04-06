{ buildPythonPackage, python, fetchurl, stdenv,
  cmake, ninja, qt5, shiboken2 }:

stdenv.mkDerivation rec {
  pname = "pyside2";
  version = "5.12.3";

  src = fetchurl {
    url = "https://download.qt.io/official_releases/QtForPython/pyside2/PySide2-${version}-src/pyside-setup-everywhere-src-${version}.tar.xz";
    sha256 = "0hk89jm8pa0q6kifask5rrffa3bvx02dg2f97ibv7wds9dysnyjg";
  };

  patches = [
    ./dont_ignore_optional_modules.patch
  ];

  postPatch = ''
    cd sources/pyside2
  '';

  cmakeFlags = [
    "-DBUILD_TESTS=OFF"
    "-DPYTHON_EXECUTABLE=${python.interpreter}"
  ];

  nativeBuildInputs = [ cmake ninja qt5.qmake shiboken2 python ];
  buildInputs = with qt5; [
    qtbase qtxmlpatterns qtmultimedia qttools qtx11extras qtlocation qtscript
    qtwebsockets qtwebengine qtwebchannel qtcharts qtsensors qtsvg
  ];

  meta = with stdenv.lib; {
    description = "LGPL-licensed Python bindings for Qt";
    license = licenses.lgpl21;
    homepage = "https://wiki.qt.io/Qt_for_Python";
    maintainers = with maintainers; [ gebner ];
  };
}
