{
  lib,
  stdenv,
  buildPythonPackage,
  fetchPypi,
  pkg-config,
  dbus,
  lndir,
  dbus-python,
  sip,
  pyqt6-sip,
  pyqt-builder,
  qt6Packages,
  pythonOlder,
  mesa,
  withMultimedia ? true,
  withWebSockets ? true,
  withLocation ? true,
  # Not currently part of PyQt6
  #, withConnectivity ? true
  withPrintSupport ? true,
  cups,
}:

buildPythonPackage rec {
  pname = "pyqt6";
  version = "6.8.0";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchPypi {
    pname = "PyQt6";
    inherit version;
    hash = "sha256-bYYo3kwqBQ8LdEYuTJy5f4Ob9v+rvKkXEXIv+ygVcNk=";
  };

  patches = [
    # Fix some wrong assumptions by ./project.py
    # TODO: figure out how to send this upstream
    # FIXME: make a version for PyQt6?
    # ./pyqt5-fix-dbus-mainloop-support.patch
    # confirm license when installing via pyqt6_sip
    ./pyqt5-confirm-license.patch
  ];

  build-system = [
    sip
    pyqt-builder
  ];

  dependencies = [
    pyqt6-sip
    dbus-python
  ];

  # be more verbose
  # and normalize version
  postPatch = ''
    cat >> pyproject.toml <<EOF
    [tool.sip.project]
    verbose = true
    EOF

    substituteInPlace pyproject.toml \
      --replace-fail 'version = "${version}"' 'version = "${lib.versions.pad 3 version}"'
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

  outputs = [
    "out"
    "dev"
  ];

  dontWrapQtApps = true;

  nativeBuildInputs =
    with qt6Packages;
    [
      pkg-config
      lndir
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
    ++ lib.optional withLocation qtlocation;

  buildInputs =
    with qt6Packages;
    [
      dbus
      qtbase
      qtsvg
      qtdeclarative
      qtquick3d
      qtquicktimeline
    ]
    # ++ lib.optional withConnectivity qtconnectivity
    ++ lib.optional withWebSockets qtwebsockets
    ++ lib.optional withLocation qtlocation;

  propagatedBuildInputs =
    # ld: library not found for -lcups
    lib.optionals (withPrintSupport && stdenv.hostPlatform.isDarwin) [ cups ];

  passthru = {
    inherit sip pyqt6-sip;
    multimediaEnabled = withMultimedia;
    WebSocketsEnabled = withWebSockets;
  };

  dontConfigure = true;

  # Checked using pythonImportsCheck, has no tests

  pythonImportsCheck =
    [
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
    ++ lib.optional withLocation "PyQt6.QtPositioning";

  env.NIX_CFLAGS_COMPILE = lib.optionalString stdenv.hostPlatform.isDarwin "-Wno-address-of-temporary";

  meta = with lib; {
    description = "Python bindings for Qt6";
    homepage = "https://riverbankcomputing.com/";
    license = licenses.gpl3Only;
    inherit (mesa.meta) platforms;
    maintainers = with maintainers; [ LunNova ];
  };
}
