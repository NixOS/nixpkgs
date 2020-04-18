{ lib, pkgs, buildPythonPackage, fetchPypi, isPy3k
, numpy
, pyqt5
, nose
}:

buildPythonPackage rec {
  pname = "qimage2ndarray";
  version = "1.8.2";
  disabled = !isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "0f792693a0f1cd5f93fbf73bc3fb2d511fb9cceed3c9308bfb200f38c19a5545";
  };

  checkInputs = [
    nose
  ];

  propagatedBuildInputs = [
    numpy
    pyqt5
  ];

  meta = {
    homepage = "https://github.com/hmeine/qimage2ndarray";
    description = "A small python extension for quickly converting between QImages and numpy.ndarrays (in both directions)";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ tbenst ];
  };
}
