{ lib
, buildPythonPackage
, isPy3k
, fetchPypi
, sip
, qtbase
, qmake
, pyqt5
, pyqt-builder
, poppler
, pkg-config
, setuptools
}:

buildPythonPackage rec {
  pname = "python-poppler-qt5";
  version = "21.3.0";

  disabled = !isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-tHfohB8OoOCf2rby8wXPON+XfZ4ULlaTo3RgXXXdb+A=";
  };


  buildInputs = [ qtbase.dev poppler pyqt-builder ];
  nativeBuildInputs = [ pkg-config qmake sip setuptools ];
  propagatedBuildInputs = [ pyqt5.dev ];

  format = "pyproject";
  dontConfigure = true;

  postPatch = ''
    cat <<EOF >> pyproject.toml
    [tool.sip.bindings.Poppler-Qt5]
    include-dirs = ["${poppler.dev}/include/poppler"]
    EOF
  '';

  # no tests, just bindings for `poppler_qt5`
  doCheck = false;
  pythonImportsCheck = [ "popplerqt5" ];

  dontWrapQtApps = true;

  meta = with lib; {
    homepage = "https://github.com/frescobaldi/python-poppler-qt5";
    license = licenses.lgpl21Plus;
    maintainers = with maintainers; [ ];
  };
}
