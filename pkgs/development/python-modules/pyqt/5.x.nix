{ lib
, stdenv
, buildPythonPackage
, setuptools
, isPy27
, fetchPypi
, pkg-config
, dbus
, lndir
, dbus-python
, sip
, pyqt5_sip
, pyqt-builder
, libsForQt5
, withConnectivity ? false
, withMultimedia ? false
, withWebKit ? false
, withWebSockets ? false
, withLocation ? false
, withSerialPort ? false
, withTools ? false
}:

buildPythonPackage rec {
  pname = "PyQt5";
  version = "5.15.9";
  format = "pyproject";

  disabled = isPy27;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-3EHoQBqQ3D4raStBG9VJKrVZrieidCTu1L05FVZOxMA=";
  };

  patches = [
    # Fix some wrong assumptions by ./project.py
    # TODO: figure out how to send this upstream
    ./pyqt5-fix-dbus-mainloop-support.patch
    # confirm license when installing via pyqt5_sip
    ./pyqt5-confirm-license.patch
  ];

  postPatch =
  # be more verbose
  ''
    cat >> pyproject.toml <<EOF
    [tool.sip.project]
    verbose = true
  ''
  # Due to bug in SIP .whl name generation we have to bump minimal macos sdk upto 11.0 for
  # aarch64-darwin. This patch can be removed once SIP will fix it in upstream,
  # see https://github.com/NixOS/nixpkgs/pull/186612#issuecomment-1214635456.
  + lib.optionalString (stdenv.isDarwin && stdenv.isAarch64) ''
    minimum-macos-version = "11.0"
  '' + ''
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

  nativeBuildInputs = with libsForQt5; [
    pkg-config
    qmake
    setuptools
    lndir
    sip
    qtbase
    qtsvg
    qtdeclarative
    qtwebchannel
  ]
    ++ lib.optional withConnectivity qtconnectivity
    ++ lib.optional withMultimedia qtmultimedia
    ++ lib.optional withWebKit qtwebkit
    ++ lib.optional withWebSockets qtwebsockets
    ++ lib.optional withLocation qtlocation
    ++ lib.optional withSerialPort qtserialport
    ++ lib.optional withTools qttools
  ;

  buildInputs = with libsForQt5; [
    dbus
    qtbase
    qtsvg
    qtdeclarative
    pyqt-builder
  ]
    ++ lib.optional withConnectivity qtconnectivity
    ++ lib.optional withWebKit qtwebkit
    ++ lib.optional withWebSockets qtwebsockets
    ++ lib.optional withLocation qtlocation
    ++ lib.optional withSerialPort qtserialport
    ++ lib.optional withTools qttools
  ;

  propagatedBuildInputs = [
    dbus-python
    pyqt5_sip
  ];

  passthru = {
    inherit sip pyqt5_sip;
    multimediaEnabled = withMultimedia;
    webKitEnabled = withWebKit;
    WebSocketsEnabled = withWebSockets;
    connectivityEnabled = withConnectivity;
    locationEnabled = withLocation;
    serialPortEnabled = withSerialPort;
    toolsEnabled = withTools;
  };

  dontConfigure = true;

  # Checked using pythonImportsCheck
  doCheck = false;

  pythonImportsCheck = [
    "PyQt5"
    "PyQt5.QtCore"
    "PyQt5.QtQml"
    "PyQt5.QtWidgets"
    "PyQt5.QtGui"
  ]
    ++ lib.optional withWebSockets "PyQt5.QtWebSockets"
    ++ lib.optional withWebKit "PyQt5.QtWebKit"
    ++ lib.optional withMultimedia "PyQt5.QtMultimedia"
    ++ lib.optional withConnectivity "PyQt5.QtBluetooth"
    ++ lib.optional withLocation "PyQt5.QtPositioning"
    ++ lib.optional withSerialPort "PyQt5.QtSerialPort"
    ++ lib.optional withTools "PyQt5.QtDesigner"
  ;

  meta = with lib; {
    description = "Python bindings for Qt5";
    homepage    = "https://riverbankcomputing.com/";
    license     = licenses.gpl3Only;
    platforms   = platforms.mesaPlatforms;
    maintainers = with maintainers; [ sander ];
  };
}
