{ lib
, buildPythonPackage
, isPy27
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
# FIXME: Once QtLocation is available for Qt6 enable this
# https://bugreports.qt.io/browse/QTBUG-96795
#, withLocation ? true
# Not currently part of PyQt6
#, withConnectivity ? true
}:

buildPythonPackage rec {
  pname = "PyQt6";
  version = "6.4.2";
  format = "pyproject";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-dAJE9gj+Fe4diWlcQ/MaFMrspBxPAqw2yG37pKXVgT0=";
  };

  patches = [
    # Fix some wrong assumptions by ./project.py
    # TODO: figure out how to send this upstream
    # FIXME: make a version for PyQt6?
    # ./pyqt5-fix-dbus-mainloop-support.patch
    # confirm license when installing via pyqt6_sip
    ./pyqt5-confirm-license.patch
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
    export MAKEFLAGS+=" -j$NIX_BUILD_CORES -l$NIX_BUILD_CORES"
  '';

  outputs = [ "out" "dev" ];

  dontWrapQtApps = true;

  nativeBuildInputs = with qt6Packages; [
    pkg-config
    lndir
    sip
    qtbase
    qtsvg
    qtdeclarative
    qtwebchannel
    qmake
    qtquick3d
    qtquicktimeline
  ]
  # ++ lib.optional withConnectivity qtconnectivity
  ++ lib.optional withMultimedia qtmultimedia
  ++ lib.optional withWebSockets qtwebsockets
  # ++ lib.optional withLocation qtlocation
  ;

  buildInputs = with qt6Packages; [
    dbus
    qtbase
    qtsvg
    qtdeclarative
    pyqt-builder
    qtquick3d
    qtquicktimeline
  ]
  # ++ lib.optional withConnectivity qtconnectivity
  ++ lib.optional withWebSockets qtwebsockets
  # ++ lib.optional withLocation qtlocation
  ;

  propagatedBuildInputs = [
    dbus-python
    pyqt6-sip
    setuptools
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
  ]
  ++ lib.optional withWebSockets "PyQt6.QtWebSockets"
  ++ lib.optional withMultimedia "PyQt6.QtMultimedia"
  # ++ lib.optional withConnectivity "PyQt6.QtConnectivity"
  # ++ lib.optional withLocation "PyQt6.QtPositioning"
  ;

  meta = with lib; {
    description = "Python bindings for Qt6";
    homepage = "https://riverbankcomputing.com/";
    license = licenses.gpl3Only;
    platforms = platforms.mesaPlatforms;
    maintainers = with maintainers; [ LunNova ];
  };
}
