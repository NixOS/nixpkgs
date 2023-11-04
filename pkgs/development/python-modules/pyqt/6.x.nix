{ lib
, stdenv
, buildPythonPackage
, fetchPypi
, pkg-config
, dbus
, lndir
, setuptools
, dbus-python
, sip
, pyqt6-sip
, pyqt-builder
, qt6Packages
, pythonOlder
, withMultimedia ? true
, withWebSockets ? true
, withLocation ? true
# Not currently part of PyQt6
#, withConnectivity ? true
, withPrintSupport ? true
, cups
, buildPackages
, pkgsBuildTarget
, pkgsHostTarget
, pkgs
}:

assert withWebSockets;

buildPythonPackage rec {
  pname = "PyQt6";
  version = "6.5.2";
  format = "pyproject";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-FIfuc1D5/7ZtYKtBdlGSUsKzcXYsvo+DQP2VH2OAEoA=";
  };

  patches = [
    # Fix some wrong assumptions by ./project.py
    # TODO: figure out how to send this upstream
    # FIXME: make a version for PyQt6?
    # ./pyqt5-fix-dbus-mainloop-support.patch
    # confirm license when installing via pyqt6_sip
    ./pyqt5-confirm-license.patch
  ] ++ lib.optionals (stdenv.buildPlatform != stdenv.hostPlatform) [
    # Adapted from Void Linux
    ./pyproject-cross.patch
  ];

  # be more verbose
  postPatch = ''
    cat >> pyproject.toml <<EOF
    [tool.sip.project]
    verbose = true
    EOF
  '';

  enableParallelBuilding = true;
  # HACK: paralellize compilation of make calls within pyqt's setup.py
  # pkgs/stdenv/generic/setup.sh doesn't set this for us because
  # make gets called by python code and not its build phase
  # format=pyproject means the pip-build-hook hook gets used to build this project
  # pkgs/development/interpreters/python/hooks/pip-build-hook.sh
  # does not use the enableParallelBuilding flag
  postUnpack = ''
    export MAKEFLAGS+="''${enableParallelBuilding:+-j$NIX_BUILD_CORES}"
  '';

  outputs = [ "out" "dev" ];

  dontWrapQtApps = true;

  nativeBuildInputs = [
    pkg-config
    lndir
    sip
    buildPackages.stdenv.cc.cc
  ] ++ (with pkgsBuildTarget.targetPackages.qt6Packages; [
    qmake
    qtbase
    qtdeclarative
    qtwebchannel
  ]);

  buildInputs = lib.optionals dbusSupport [
    dbus
  ] ++ (with qt6Packages; [
    qtbase
    qtbase.dev
    qtsvg
    qtdeclarative
    pyqt-builder
    qtquick3d
    qtwebchannel
    qtwebchannel.dev
    qtquicktimeline
  ]
  # ++ lib.optional withConnectivity qtconnectivity
  ++ lib.optional withMultimedia qtmultimedia
  ++ lib.optional withWebSockets qtwebsockets
  ++ lib.optional withLocation qtlocation
  );

  propagatedBuildInputs = [
    dbus-python
    pyqt6-sip
    setuptools
  ]
  # ld: library not found for -lcups
  ++ lib.optionals (withPrintSupport && stdenv.isDarwin) [
    cups
  ];

  passthru = {
    inherit sip pyqt6-sip;
    multimediaEnabled = withMultimedia;
    WebSocketsEnabled = withWebSockets;
  };

  dontConfigure = true;

  # Checked using pythonImportsCheck, has no tests
  doCheck = true;

  pythonImportsCheck = [
    "PyQt6"
    "PyQt6.QtCore"
    "PyQt6.QtQml"
    "PyQt6.QtWidgets"
    "PyQt6.QtGui"
    "PyQt6.QtQuick"
    "PyQt6.QtWebChannel"
  ]
  ++ lib.optional withWebSockets "PyQt6.QtWebSockets"
  ++ lib.optional withMultimedia "PyQt6.QtMultimedia"
  # ++ lib.optional withConnectivity "PyQt6.QtConnectivity"
  ++ lib.optional withLocation "PyQt6.QtPositioning"
  ;

  env = {
    NIX_CFLAGS_COMPILE = lib.concatStringsSep " " ([
      # fix build with qt 6.6
      "-fpermissive"
    ] ++ lib.optionals (stdenv.buildPlatform != stdenv.hostPlatform) [
      "-Wno-cast-function-type"
    ]);
  } // lib.optionalAttrs (stdenv.buildPlatform != stdenv.hostPlatform) {
    EMULATOR = stdenv.hostPlatform.emulator buildPackages;
  };

  meta = with lib; {
    description = "Python bindings for Qt6";
    homepage = "https://riverbankcomputing.com/";
    license = licenses.gpl3Only;
    platforms = platforms.mesaPlatforms;
    maintainers = with maintainers; [ LunNova ];
  };
}
