{ lib
, stdenv
, cmake
, ninja
, qt6
, python
, shiboken6
, libxcrypt
}:

stdenv.mkDerivation rec {
  #pname = "PySide6";
  pname = "pyside6";
  inherit (shiboken6) version src;

  postPatch = ''
    # dont ignore optional qt modules
    substituteInPlace sources/pyside6/cmake/PySideHelpers.cmake \
      --replace \
        'string(FIND "''${_module_dir}" "''${_core_abs_dir}" found_basepath)' \
        'set (found_basepath 0)'

    cd sources/${pname}
  '';

  nativeBuildInputs = [
    cmake
    ninja
  ];

  buildInputs = [
    python
  ] ++ (with qt6; [
    # required
    qtbase
    # optional
    qt3d
    qtcharts
    qtconnectivity
    qtdatavis3d
    qtdeclarative
    qthttpserver
    qtmultimedia
    qtnetworkauth
    qtquick3d
    qtremoteobjects
    qtscxml
    qtsensors
    qtspeech
    qtsvg
    qttools
    qtwebchannel
    qtwebengine
    qtwebsockets
  ]) ++ (lib.optionals (python.pythonOlder "3.9") [
    # see similar issue: 202262
    # libxcrypt is required for crypt.h for building older python modules
    libxcrypt
  ]);

  propagatedBuildInputs = [
    shiboken6
  ];

  cmakeFlags = [
    "-DBUILD_TESTS=OFF"
  ];

  dontWrapQtApps = true;

  meta = with lib; {
    description = "Python bindings for Qt";
    license = licenses.lgpl21;
    homepage = "https://wiki.qt.io/Qt_for_Python";
    maintainers = with maintainers; [ milahu ];
  };
}
