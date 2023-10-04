{ lib
, stdenv
, fetchpatch2
, cmake
, ninja
, python
, moveBuildTree
, shiboken6
, libxcrypt
}:

stdenv.mkDerivation rec {
  pname = "pyside6";

  inherit (shiboken6) version src;

  sourceRoot = "pyside-setup-everywhere-src-${version}/sources/${pname}";

  patches = [
    # Needed to build against qt 6.5.3, until pyside 6.5.3 is released
    (fetchpatch2 {
      url = "https://code.qt.io/cgit/pyside/pyside-setup.git/patch/sources/pyside6?id=63ef7628091c8827e3d0d688220d3ae165587eb2";
      hash = "sha256-TN1xdBkrzZhNontShMC1SKyJK6a8fOk/Di3zX3kv5+I=";
      stripLen = 2;
    })
  ];

  # FIXME: cmake/Macros/PySideModules.cmake supposes that all Qt frameworks on macOS
  # reside in the same directory as QtCore.framework, which is not true for Nix.
  postPatch = lib.optionalString stdenv.isLinux ''
    # Don't ignore optional Qt modules
    substituteInPlace cmake/PySideHelpers.cmake \
      --replace \
        'string(FIND "''${_module_dir}" "''${_core_abs_dir}" found_basepath)' \
        'set (found_basepath 0)'
  '';

  nativeBuildInputs = [
    cmake
    ninja
    python
  ] ++ lib.optionals stdenv.isDarwin [
    moveBuildTree
  ];

  buildInputs = with python.pkgs.qt6; [
    # required
    qtbase
    python.pkgs.ninja
    python.pkgs.packaging
    python.pkgs.setuptools
  ] ++ lib.optionals stdenv.isLinux [
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
  ];

  propagatedBuildInputs = [
    shiboken6
  ];

  cmakeFlags = [
    "-DBUILD_TESTS=OFF"
  ];

  dontWrapQtApps = true;

  postInstall = ''
    cd ../../..
    ${python.pythonForBuild.interpreter} setup.py egg_info --build-type=pyside6
    cp -r PySide6.egg-info $out/${python.sitePackages}/
  '';

  meta = with lib; {
    description = "Python bindings for Qt";
    license = with licenses; [ lgpl3Only gpl2Only gpl3Only ];
    homepage = "https://wiki.qt.io/Qt_for_Python";
    maintainers = with maintainers; [ gebner Enzime ];
    platforms = platforms.all;
  };
}
