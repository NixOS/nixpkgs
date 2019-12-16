{ lib, pkgs, buildPythonPackage, fetchPypi, isPy3k
, numpy
, pyqt5
, nose
}:

buildPythonPackage rec {
  pname = "qimage2ndarray";
  version = "1.8";
  disabled = !isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "7b9eb08a9be27f5439289d90d7d5a5942aad403d5634fe336eb915678c65db48";
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
