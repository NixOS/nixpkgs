{ lib, buildPythonPackage, fetchPypi, isPy3k
, numpy
, pyqt5
}:

buildPythonPackage rec {
  pname = "qimage2ndarray";
  version = "1.10.0";
  format = "setuptools";
  disabled = !isPy3k;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-NyUQJEbcimlrLsd1sdKvQ7E69qf56+6KNxFbuVQ6LFg=";
  };

  propagatedBuildInputs = [
    numpy
    pyqt5
  ];

  # no tests executed
  doCheck = false;

  meta = {
    homepage = "https://github.com/hmeine/qimage2ndarray";
    description = "A small python extension for quickly converting between QImages and numpy.ndarrays (in both directions)";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ tbenst ];
  };
}
