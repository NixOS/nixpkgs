{ python
, pythonAtLeast
, disabledIf
, fetchurl
, lib
, stdenv
, cmake
, libxcrypt
, ninja
, qt5
, shiboken2
}:
stdenv.mkDerivation rec {
  pname = "pyside2";
  version = "5.15.11";

  src = fetchurl {
    url = "https://download.qt.io/official_releases/QtForPython/pyside2/PySide2-${version}-src/pyside-setup-opensource-src-${version}.tar.xz";
    sha256 = "sha256-2lZ807eFTSegtK/j6J3osvmLem1XOTvlbx/BP3cPryk=";
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

  env.NIX_CFLAGS_COMPILE = "-I${qt5.qtdeclarative.dev}/include/QtQuick/${qt5.qtdeclarative.version}/QtQuick";

  nativeBuildInputs = [ cmake ninja qt5.qmake python ];

  buildInputs = (with qt5; [
    qtbase
    qtxmlpatterns
    qtmultimedia
    qttools
    qtx11extras
    qtlocation
    qtscript
    qtwebsockets
    qtwebengine
    qtwebchannel
    qtcharts
    qtsensors
    qtsvg
    qt3d
  ]) ++ (with python.pkgs; [
    setuptools
  ]) ++ (lib.optionals (python.pythonOlder "3.9") [
    # see similar issue: 202262
    # libxcrypt is required for crypt.h for building older python modules
    libxcrypt
  ]);

  propagatedBuildInputs = [ shiboken2 ];

  dontWrapQtApps = true;

  postInstall = ''
    cd ../../..
    ${python.pythonOnBuildForHost.interpreter} setup.py egg_info --build-type=pyside2
    cp -r PySide2.egg-info $out/${python.sitePackages}/
  '';

  meta = with lib; {
    description = "LGPL-licensed Python bindings for Qt";
    license = licenses.lgpl21;
    homepage = "https://wiki.qt.io/Qt_for_Python";
    maintainers = with maintainers; [ gebner ];
  };
}
