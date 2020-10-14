{ lib, pythonPackages, pkgconfig
, qmake, qtbase, qtsvg, qtwebengine
, wrapQtAppsHook
}:

let

  inherit (pythonPackages) buildPythonPackage python isPy3k pyqt5 enum34;
  inherit (pyqt5) sip;
  # source: https://www.riverbankcomputing.com/pipermail/pyqt/2020-June/042985.html
  patches = lib.optional (lib.hasPrefix "5.14" pyqt5.version)
    [ ./fix-build-with-qt-514.patch ]
  ;

in buildPythonPackage rec {
  pname = "PyQtWebEngine";
  version = "5.15.0";
  format = "other";

  src = pythonPackages.fetchPypi {
    inherit pname version;
    sha256 = "0xdzhl07x3mzfnr5cf4d640168vxi7fyl0fz1pvpbgs0irl14237";
  };

  inherit patches;

  outputs = [ "out" "dev" ];

  nativeBuildInputs = [
    pkgconfig
    qmake
    sip
    qtbase
    qtsvg
    qtwebengine
  ];

  buildInputs = [
    sip
    qtbase
    qtsvg
    qtwebengine
  ];

  propagatedBuildInputs = [ pyqt5 ]
    ++ lib.optional (!isPy3k) enum34;

  configurePhase = ''
    runHook preConfigure

    mkdir -p "$out/share/sip/PyQt5"

    # FIXME: Without --no-dist-info, I get
    #     unable to create /nix/store/yv4pzx3lxk3lscq0pw3hqzs7k4x76xsm-python3-3.7.2/lib/python3.7/site-packages/PyQtWebEngine-5.12.dist-info
    ${python.executable} configure.py -w \
      --destdir="$out/${python.sitePackages}/PyQt5" \
      --no-dist-info \
      --apidir="$out/api/${python.libPrefix}" \
      --sipdir="$out/share/sip/PyQt5" \
      --pyqt-sipdir="${pyqt5}/share/sip/PyQt5" \
      --stubsdir="$out/${python.sitePackages}/PyQt5"

    runHook postConfigure
  '';

  postInstall = ''
    # Let's make it a namespace package
    cat << EOF > $out/${python.sitePackages}/PyQt5/__init__.py
    from pkgutil import extend_path
    __path__ = extend_path(__path__, __name__)
    EOF
  '';

  installCheckPhase = let
    modules = [
      "PyQt5.QtWebEngine"
      "PyQt5.QtWebEngineWidgets"
    ];
    imports = lib.concatMapStrings (module: "import ${module};") modules;
  in ''
    echo "Checking whether modules can be imported..."
    PYTHONPATH=$PYTHONPATH:$out/${python.sitePackages} ${python.interpreter} -c "${imports}"
  '';

  doCheck = true;

  enableParallelBuilding = true;

  passthru = {
    inherit wrapQtAppsHook;
  };

  meta = with lib; {
    description = "Python bindings for Qt5";
    homepage    = "http://www.riverbankcomputing.co.uk";
    license     = licenses.gpl3;
    platforms   = platforms.mesaPlatforms;
  };
}
