# NOTE: updating pyqt6 usually requires updating:
# * pyqt6-builder in pkgs/development/python-modules/pyqt-builder/6.nix
# * sip-pyqt6 in pkgs/development/python-modules/sip/pyqt6.nix
# * pyqt6_sip in pkgs/development/python-modules/pyqt/sip6.nix
# * pyqt6-webengine in pkgs/development/python-modules/pyqtwebengine/6.nix

{ lib
, buildPythonPackage
, isPy27
, fetchPypi
, pkg-config
, dbus
, lndir
, dbus-python
, sip-pyqt6
, pyqt6_sip
, pyqt6-builder
, qmake2cmake
, cmake
, qt6Packages
, python
, withConnectivity ? true
, withMultimedia ? true
, withWebSockets ? true
, withLocation ? true
}:

buildPythonPackage rec {
  pname = "PyQt6";
  # TODO assert version == qt6Packages.qtbase.version
  version = "6.3.1";
  format = "pyproject";

  disabled = isPy27;

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-jMbiHbr3BH0fyJfjlszZcQoS8u+XZWPa1l8GAX0sl1c=";
  };

  outputs = [ "out" "dev" ];

  # debug cmake
  #cmakeFlags = [ "--debug-output" ];
  #cmakeFlags = [ "--trace-expand" ];

  # uncomment to debug qmake2cmake
  #QMAKE2CMAKE_DEBUG = "1";
  SIP_DEBUG = "1";
  #PYQT_BUILDER_DEBUG = "1";
  # uncomment to dump generated files to stdout
  #QMAKE2CMAKE_DEBUG_DUMP_FILES = "1";
  #PYQT_BUILDER_DEBUG_DUMP_MAKE_FILES = "1";
  #SIP_DEBUG_DUMP_FILES = "1";

  dontWrapQtApps = true;

  nativeBuildInputs = with qt6Packages; [
    pkg-config
    lndir
    sip-pyqt6
    qtbase
    qmake2cmake
    cmake
    qtsvg
    qtdeclarative
    qtwebchannel
  ]
    ++ lib.optional withConnectivity qtconnectivity
    ++ lib.optional withMultimedia qtmultimedia
    ++ lib.optional withWebSockets qtwebsockets
    ++ lib.optional withLocation qtpositioning;

  buildInputs = with qt6Packages; [
    dbus
    qtbase
    qtwayland
    qtsvg
    qtdeclarative
    pyqt6-builder
  ]
    ++ lib.optional withConnectivity qtconnectivity
    ++ lib.optional withWebSockets qtwebsockets
    ++ lib.optional withLocation qtpositioning;

  propagatedBuildInputs = [
    dbus-python
    pyqt6_sip
  ];

  patches = [
    ./pyqt6-fix-find-dbus-python.patch

    # TODO reduce patch to
    # if tool in {'pep517', 'wheel'}:
    ./debug-dbus-abi-version-blah.patch
  ];

  passthru = {
    inherit sip-pyqt6 pyqt6_sip;
    multimediaEnabled = withMultimedia;
    WebSocketsEnabled = withWebSockets;
  };

  enableParallelBuilding = true;

  dontConfigure = true;

  # help sip-pyqt6 to import /build/PyQt6-6.3.0/project.py
  preBuild = ''
    export PYTHONPATH="$PWD:$PYTHONPATH"
  '';

  doCheck = false;

  pythonImportsCheck = [
    "PyQt6"
    "PyQt6.QtCore"
    "PyQt6.QtNetwork"
    "PyQt6.QtSql"
    "PyQt6.QtSvg"
    "PyQt6.QtXml"
    "PyQt6.QtQml"
    "PyQt6.QtQuick"
    "PyQt6.QtQuickWidgets"
    "PyQt6.QtWidgets"
    "PyQt6.QtGui"
    "PyQt6.QtWidgets"
    "PyQt6.QtPrintSupport"
  ]
    ++ lib.optionals withWebSockets [
      "PyQt6.QtWebSockets"
      "PyQt6.QtWebChannel"
    ]
    ++ lib.optionals withMultimedia [
      "PyQt6.QtMultimedia"
      "PyQt6.QtMultimediaWidgets"
    ]
    ++ lib.optionals withConnectivity [
      "PyQt6.QtBluetooth"
      "PyQt6.QtNfc"
      "PyQt6.QtSerialPort"
    ]
    ++ lib.optional withLocation "PyQt6.QtPositioning";

  /*
    TODO? check imports
    QtDBus
    QtOpenGL
    QtOpenGLWidgets
  */

  meta = with lib; {
    description = "Python bindings for Qt6";
    homepage    = "https://riverbankcomputing.com/";
    license     = licenses.gpl3Only;
    platforms   = platforms.mesaPlatforms;
    maintainers = with maintainers; [ nrdxp milahu ];
  };
}
