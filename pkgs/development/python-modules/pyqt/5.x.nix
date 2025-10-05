{
  lib,
  stdenv,
  buildPythonPackage,
  setuptools,
  isPy27,
  fetchPypi,
  pkg-config,
  dbus,
  lndir,
  dbus-python,
  sip,
  pyqt5-sip,
  pyqt-builder,
  libsForQt5,
  mesa,
  enableVerbose ? true,
  withConnectivity ? false,
  withMultimedia ? false,
  withWebKit ? false,
  withWebSockets ? false,
  withLocation ? false,
  withSerialPort ? false,
  withTools ? false,
  pkgsBuildTarget,
  dbusSupport ? !stdenv.hostPlatform.isDarwin,
}:

buildPythonPackage rec {
  pname = "pyqt5";
  version = "5.15.10";
  format = "pyproject";

  disabled = isPy27;

  src = fetchPypi {
    pname = "PyQt5";
    inherit version;
    hash = "sha256-1Gt4BLGxCk/5F1P4ET5bVYDStEYvMiYoji2ESXM0iYo=";
  };

  patches = [
    # Fix some wrong assumptions by ./project.py
    # TODO: figure out how to send this upstream
    ./pyqt5-fix-dbus-mainloop-support.patch
    # confirm license when installing via pyqt5-sip
    ./pyqt5-confirm-license.patch
  ];

  postPatch =
    # be more verbose
    ''
      cat >> pyproject.toml <<EOF
    ''
    + lib.optionalString enableVerbose ''
      [tool.sip.project]
      verbose = true
    ''
    # Due to bug in SIP .whl name generation we have to bump minimal macos sdk upto 11.0 for
    # aarch64-darwin. This patch can be removed once SIP will fix it in upstream,
    # see https://github.com/NixOS/nixpkgs/pull/186612#issuecomment-1214635456.
    + lib.optionalString (stdenv.hostPlatform.isDarwin && stdenv.hostPlatform.isAarch64) ''
      minimum-macos-version = "11.0"
    ''
    + ''
      EOF
    ''

    # pyqt-builder tries to compile *and run* these programs.  This
    # is really sad because the only thing they do is print out a
    # flag based on whether or not some compile-time symbol was
    # defined.  This could all be done without having to *execute*
    # cross-compiled programs!
    #
    # Here is the complete list of things checked:
    #
    # QT_NO_PRINTDIALOG                                                           => PyQt_PrintDialog
    # QT_NO_PRINTER                                                               => PyQt_Printer
    # QT_NO_PRINTPREVIEWDIALOG                                                    => PyQt_PrintPreviewDialog
    # QT_NO_PRINTPREVIEWWIDGET                                                    => PyQt_PrintPreviewWidget
    # QT_NO_SSL                                                                   => PyQt_SSL
    # QT_SHARED || QT_DLL                                                         => shared (otherwise static)
    # QT_NO_PROCESS                                                               => PyQt_Process
    # QT_NO_FPU || Q_PROCESSOR_ARM || Q_OS_WINCE                                  => PyQt_qreal_double
    # sizeof (qreal) != sizeof (double)                                           => PyQt_qreal_double
    # !Q_COMPILER_CONSTEXPR !Q_COMPILER_UNIFORM_INIT                              => PyQt_CONSTEXPR
    # QT_NO_ACCESSIBILITY                                                         => PyQt_Accessibility
    # QT_NO_OPENGL                                                                => PyQt_OpenGL PyQt_Desktop_OpenGL
    # defined(QT_OPENGL_ES) || defined(QT_OPENGL_ES_2) || defined(QT_OPENGL_ES_3) => PyQt_Desktop_OpenGL
    # QT_NO_RAWFONT                                                               => PyQt_RawFont
    # QT_NO_SESSIONMANAGER                                                        => PyQt_SessionManager
    #
    + lib.optionalString (!(stdenv.buildPlatform.canExecute stdenv.hostPlatform)) ''
      rm config-tests/cfgtest_QtCore.cpp
      rm config-tests/cfgtest_QtGui.cpp
      rm config-tests/cfgtest_QtNetwork.cpp
      rm config-tests/cfgtest_QtPrintSupport.cpp
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

  # tons of warnings from subpackages, no point in playing whack-a-mole
  env = lib.optionalAttrs (!enableVerbose) { NIX_CFLAGS_COMPILE = "-w"; };

  outputs = [
    "out"
    "dev"
  ];

  dontWrapQtApps = true;

  nativeBuildInputs = [
    pkg-config
  ]
  ++ lib.optionals (stdenv.buildPlatform == stdenv.hostPlatform) [ libsForQt5.qmake ]
  ++ [
    setuptools
    lndir
    sip
  ]
  ++ (
    with pkgsBuildTarget.targetPackages.libsForQt5;
    [ ]
    ++ lib.optionals (stdenv.buildPlatform != stdenv.hostPlatform) [ qmake ]
    ++ [
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
  );

  buildInputs =
    with libsForQt5;
    [ dbus ]
    ++ lib.optionals (stdenv.buildPlatform == stdenv.hostPlatform) [ qtbase ]
    ++ [
      qtsvg
      qtdeclarative
      pyqt-builder
    ]
    ++ lib.optional withConnectivity qtconnectivity
    ++ lib.optional withWebKit qtwebkit
    ++ lib.optional withWebSockets qtwebsockets
    ++ lib.optional withLocation qtlocation
    ++ lib.optional withSerialPort qtserialport
    ++ lib.optional withTools qttools;

  propagatedBuildInputs = [
    dbus-python
    pyqt5-sip
  ];

  passthru = {
    inherit sip pyqt5-sip;
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
  ++ lib.optional withTools "PyQt5.QtDesigner";

  meta = with lib; {
    description = "Python bindings for Qt5";
    homepage = "https://riverbankcomputing.com/";
    license = licenses.gpl3Only;
    inherit (mesa.meta) platforms;
    maintainers = with maintainers; [ sander ];
  };
}
