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
    ++ lib.optional withConnectivity "PyQt5.QtConnectivity"
    ++ lib.optional withLocation "PyQt5.QtPositioning"
  ;

  meta = with lib; {
    description = "Python bindings for Qt5";
    homepage    = "https://riverbankcomputing.com/";
    license     = licenses.gpl3Only;
    platforms   = platforms.mesaPlatforms;
    maintainers = with maintainers; [ sander ];
  };
}
