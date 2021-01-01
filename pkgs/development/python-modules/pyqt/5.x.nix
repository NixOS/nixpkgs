{ lib, pythonPackages, pkgconfig
, dbus
, qmake, lndir
, qtbase
, qtsvg
, qtdeclarative
, qtwebchannel
, withConnectivity ? false, qtconnectivity
, withMultimedia ? false, qtmultimedia
, withWebKit ? false, qtwebkit
, withWebSockets ? false, qtwebsockets
}:

let

  inherit (pythonPackages) buildPythonPackage python isPy3k dbus-python enum34;

  sip = (pythonPackages.sip.override { sip-module = "PyQt5.sip"; }).overridePythonAttrs(oldAttrs: {
    # If we install sip in another folder, then we need to create a __init__.py as well
    # if we want to be able to import it with Python 2.
    # Python 3 could rely on it being an implicit namespace package, however,
    # PyQt5 we made an explicit namespace package so sip should be as well.
    postInstall = ''
      cat << EOF > $out/${python.sitePackages}/PyQt5/__init__.py
      from pkgutil import extend_path
      __path__ = extend_path(__path__, __name__)
      EOF
    '';
  });

in buildPythonPackage rec {
  pname = "PyQt5";
  version = "5.15.2";
  format = "other";

  src = pythonPackages.fetchPypi {
    inherit pname version;
    sha256 = "1z74295i69cha52llsqffzhb5zz7qnbjc64h8qg21l91jgf0harp";
  };

  outputs = [ "out" "dev" ];

  nativeBuildInputs = [
    pkgconfig
    qmake
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
  ;

  buildInputs = [
    dbus
    qtbase
    qtsvg
    qtdeclarative
  ]
    ++ lib.optional withConnectivity qtconnectivity
    ++ lib.optional withWebKit qtwebkit
    ++ lib.optional withWebSockets qtwebsockets
  ;

  propagatedBuildInputs = [
    dbus-python
    sip
  ] ++ lib.optional (!isPy3k) enum34;

  patches = [
    # Fix some wrong assumptions by ./configure.py
    # TODO: figure out how to send this upstream
    ./pyqt5-fix-dbus-mainloop-support.patch
  ];

  passthru = {
    inherit sip;
    multimediaEnabled = withMultimedia;
    webKitEnabled = withWebKit;
    WebSocketsEnabled = withWebSockets;
  };

  configurePhase = ''
    runHook preConfigure

    export PYTHONPATH=$PYTHONPATH:$out/${python.sitePackages}

    ${python.executable} configure.py  -w \
      --confirm-license \
      --dbus-moduledir=$out/${python.sitePackages}/dbus/mainloop \
      --no-qml-plugin \
      --bindir=$out/bin \
      --destdir=$out/${python.sitePackages} \
      --stubsdir=$out/${python.sitePackages}/PyQt5 \
      --sipdir=$out/share/sip/PyQt5 \
      --designer-plugindir=$out/plugins/designer

    runHook postConfigure
  '';

  postInstall = ''
    ln -s ${sip}/${python.sitePackages}/PyQt5/sip.* $out/${python.sitePackages}/PyQt5/
    for i in $out/bin/*; do
      wrapProgram $i --prefix PYTHONPATH : "$PYTHONPATH"
    done

    # Let's make it a namespace package
    cat << EOF > $out/${python.sitePackages}/PyQt5/__init__.py
    from pkgutil import extend_path
    __path__ = extend_path(__path__, __name__)
    EOF
  '';

  installCheckPhase = let
    modules = [
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
    ;
    imports = lib.concatMapStrings (module: "import ${module};") modules;
  in ''
    echo "Checking whether modules can be imported..."
    ${python.interpreter} -c "${imports}"
  '';

  doCheck = true;

  enableParallelBuilding = true;

  meta = with lib; {
    description = "Python bindings for Qt5";
    homepage    = "http://www.riverbankcomputing.co.uk";
    license     = licenses.gpl3;
    platforms   = platforms.mesaPlatforms;
    maintainers = with maintainers; [ sander ];
  };
}
