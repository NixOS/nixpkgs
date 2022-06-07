{ lib
, pythonPackages
, qtcharts
, qtbase
, qmake
, pkg-config
}:


let
  inherit (pythonPackages) buildPythonPackage fetchPypi python sip pqtcharts pyqt5 pyqt-builder;
in buildPythonPackage rec {
  pname = "PyQtChart";
  version = qtcharts.version;
  src = fetchPypi {
    inherit version;
    inherit pname;
    sha256 = "1kxwhkp4mwrhdcfbcqimrhqhiglzsrr2c6mfqr60vralk9ld0m2z";
  };
  format = "pyproject";

  nativeBuildInputs = [ sip pkg-config qmake qtcharts pyqt-builder ];
  propagatedBuildInputs = [ pyqt5 ];

  dontWrapQtApps = true;
  dontConfigure = true;

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace "[tool.sip.project]" "[tool.sip.project]''\nsip-include-dirs = [\"${pyqt5}/${python.sitePackages}/PyQt5/bindings\"]" \
      --replace "\"PyQtChart-Qt (>=5.15)\"," ""
  '';

  postInstall = ''
    export PYTHONPATH="$out/${python.sitePackages}:$PYTHONPATH"
  '';

  pythonImportsCheck = [ "PyQt5.QtChart" ];

  meta = with lib; {
    description = "PyQtChart is a set of Python bindings for The Qt Company’s Qt Charts library. The bindings sit on top of PyQt5 and are implemented as a single module";
    homepage = "https://www.riverbankcomputing.com/software/pyqtchart/";
    license = with licenses; [ lgpl3 ];
    maintainers = with maintainers; [ malbarbo ];
  };
}
