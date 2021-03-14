{ buildPythonPackage, python, fetchurl, lib, stdenv,
  cmake, ninja, qt5, shiboken2 }:

stdenv.mkDerivation rec {
  pname = "pyside2";
  version = "5.15.2";

  src = fetchurl {
    url = "https://download.qt.io/official_releases/QtForPython/pyside2/PySide2-${version}-src/pyside-setup-opensource-src-${version}.tar.xz";
    sha256 = "060ljj1nzyp4zfz2vasbv2i7gs5rfkkjwxxbisd0fdw01d5m01mk";
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

  nativeBuildInputs = [ cmake ninja qt5.qmake python ];
  buildInputs = with qt5; [
    qtbase qtxmlpatterns qtmultimedia qttools qtx11extras qtlocation qtscript
    qtwebsockets qtwebengine qtwebchannel qtcharts qtsensors qtsvg
  ];
  propagatedBuildInputs = [ shiboken2 ];

  dontWrapQtApps = true;

  meta = with lib; {
    description = "LGPL-licensed Python bindings for Qt";
    license = licenses.lgpl21;
    homepage = "https://wiki.qt.io/Qt_for_Python";
    maintainers = with maintainers; [ gebner ];
  };
}
