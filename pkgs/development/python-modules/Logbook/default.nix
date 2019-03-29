{ lib, buildPythonPackage, fetchPypi, isPy3k, pytest, mock, brotli }:

buildPythonPackage rec {
  pname = "Logbook";
  version = "1.4.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "a5a96792abd8172c80d61b7530e134524f20e2841981038031e602ed5920fef5";
  };

  checkInputs = [ pytest ] ++ lib.optionals (!isPy3k) [ mock ];

  propagatedBuildInputs = [ brotli ];

  checkPhase = ''
    find tests -name \*.pyc -delete
    py.test tests
  '';

  meta = {
    homepage = https://pythonhosted.org/Logbook/;
    description = "A logging replacement for Python";
    license = lib.licenses.bsd3;
  };
}
