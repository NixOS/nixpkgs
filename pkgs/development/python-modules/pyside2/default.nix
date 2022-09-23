{ python, fetchurl, lib, stdenv,
  cmake, ninja, qt5, shiboken2 }:

stdenv.mkDerivation rec {
  pname = "pyside2";
  version = "5.15.5";

  src = fetchurl {
    url = "https://download.qt.io/official_releases/QtForPython/pyside2/PySide2-${version}-src/pyside-setup-opensource-src-${version}.tar.xz";
    sha256 = "0cwvw6695215498rsbm2xzkwaxdr3w7zfvy4kc62c01k6pxs881r";
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
  buildInputs = (with qt5; [
    qtbase qtxmlpatterns qtmultimedia qttools qtx11extras qtlocation qtscript
    qtwebsockets qtwebengine qtwebchannel qtcharts qtsensors qtsvg
  ]) ++ [
    python.pkgs.setuptools
  ];
  propagatedBuildInputs = [ shiboken2 ];

  dontWrapQtApps = true;

  postInstall = ''
    cd ../../..
    ${python.interpreter} setup.py egg_info --build-type=pyside2
    cp -r PySide2.egg-info $out/${python.sitePackages}/
  '';

  meta = with lib; {
    description = "LGPL-licensed Python bindings for Qt";
    license = licenses.lgpl21;
    homepage = "https://wiki.qt.io/Qt_for_Python";
    maintainers = with maintainers; [ gebner ];
  };
}
