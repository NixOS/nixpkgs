{ lib
, stdenv
, cmake
, ninja
<<<<<<< HEAD
=======
, qt6
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, python
, moveBuildTree
, shiboken6
, libxcrypt
}:

stdenv.mkDerivation rec {
  pname = "pyside6";

  inherit (shiboken6) version src;

<<<<<<< HEAD
  sourceRoot = "pyside-setup-everywhere-src-${version}/sources/${pname}";
=======
  sourceRoot = "pyside-setup-everywhere-src-${lib.versions.majorMinor version}/sources/${pname}";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

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

<<<<<<< HEAD
  buildInputs = with python.pkgs.qt6; [
    # required
    qtbase
    python.pkgs.ninja
    python.pkgs.packaging
    python.pkgs.setuptools
=======
  buildInputs = with qt6; [
    # required
    qtbase
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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

<<<<<<< HEAD
  postInstall = ''
    cd ../../..
    ${python.pythonForBuild.interpreter} setup.py egg_info --build-type=pyside6
    cp -r PySide6.egg-info $out/${python.sitePackages}/
  '';

=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  meta = with lib; {
    description = "Python bindings for Qt";
    license = with licenses; [ lgpl3Only gpl2Only gpl3Only ];
    homepage = "https://wiki.qt.io/Qt_for_Python";
    maintainers = with maintainers; [ gebner Enzime ];
    platforms = platforms.all;
  };
}
