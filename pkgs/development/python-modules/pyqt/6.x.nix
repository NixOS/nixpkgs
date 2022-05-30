{ lib
, buildPythonPackage
, python
, isPy27
, fetchPypi
, pkg-config
, dbus
, lndir
, dbus-python
, sip
, pyqt6_sip
, pyqt-builder
, qt6Packages
, symlinkJoin
, makeWrapper
, withConnectivity ? false
, withMultimedia ? false
, withWebSockets ? false
, withLocation ? false
}:
let
  # FIXME: qmake no longer supports splitting outputs into various paths
  # It also doesn't like symlinks, so the only option for now is to simply
  # copy all dependencies under a single directory.
  qt6Libs = with qt6Packages;
    (symlinkJoin {
      name = "qt6-libs";
      paths = lib.flatten (map (x: [x.out x.dev]) [
        qtbase
        qtdeclarative
        qtsvg
        qtwebchannel
      ]
        ++ lib.optional withConnectivity qtconnectivity
        ++ lib.optional withMultimedia qtmultimedia
        ++ lib.optional withWebSockets qtwebsockets
        ++ lib.optional withLocation qtpositioning
    );})
    .overrideAttrs (o: {
      buildCommand = builtins.concatStringsSep "\n" [
        o.buildCommand
        ''
         ( TMPLINKS=$(mktemp -u)
            trap "rm -rf $TMPLINKS" EXIT

            mv $out $TMPLINKS

            cp --reflink=auto -rL $TMPLINKS $out
         )
        ''
      ];
    });

    out = placeholder "out";

in buildPythonPackage rec {
  pname = "PyQt6";
  version = "6.3.1";
  format = "pyproject";

  disabled = isPy27;

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-jMbiHbr3BH0fyJfjlszZcQoS8u+XZWPa1l8GAX0sl1c=";
  };

  outputs = [ "out" "dev" ];

  dontWrapQtApps = true;

  nativeBuildInputs = with qt6Packages; [
    pkg-config
    lndir
    sip
    qt6Libs
    makeWrapper
  ];

  buildInputs = with qt6Packages; [
    dbus
    qt6Libs
    pyqt-builder
  ];

  propagatedBuildInputs = [
    dbus-python
    pyqt6_sip
  ];

  patches = [
    # TODO: contribute upstream
    ./pyqt6-fix-find-dbus-python.patch
  ];

  passthru = {
    inherit sip pyqt6_sip;
    multimediaEnabled = withMultimedia;
    WebSocketsEnabled = withWebSockets;
  };

  configurePhase = ''
    runHook preConfigure

    export PYTHONPATH=$PYTHONPATH:${out}/lib/${python.libPrefix}/site-packages

    sip-build --no-make \
     --confirm-license \
     --build-dir=dist \
     --target-dir=${out}/lib/${python.libPrefix}/site-packages \
     --scripts-dir=${out}/bin \
     --no-qml-plugin

    runHook postConfigure
  '';

  # Checked using pythonImportsCheck
  doCheck = false;

  buildPhase = ''
    cd dist
    make -j "$NIX_BUILD_CORES"
  '';

  installPhase = ''
    runHook preInstall

    make install -j "$NIX_BUILD_CORES"

    runHook postInstall
  '';

  postInstall = ''
    for i in ${out}/bin/*; do
      wrapProgram $i --prefix PYTHONPATH : "$PYTHONPATH"
    done
  '';

  pythonImportsCheck = [
    "PyQt6"
    "PyQt6.QtCore"
    "PyQt6.QtQml"
    "PyQt6.QtWidgets"
    "PyQt6.QtGui"
  ]
    ++ lib.optional withWebSockets "PyQt6.QtWebSockets"
    ++ lib.optional withMultimedia "PyQt6.QtMultimedia"
    ++ lib.optional withConnectivity "PyQt6.QtConnectivity"
    ++ lib.optional withLocation "PyQt6.QtPositioning";

  meta = with lib; {
    description = "Python bindings for Qt6";
    homepage    = "https://riverbankcomputing.com/";
    license     = licenses.gpl3Only;
    platforms   = platforms.mesaPlatforms;
    maintainers = with maintainers; [ nrdxp ];
  };
}
