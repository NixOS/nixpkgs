{ buildPythonPackage, fetchPypi, lib, numpy, pytest, pytestpep8, pytestcov }:
buildPythonPackage rec {
  version = "2.3.2";
  pname = "opt_einsum";

  src = fetchPypi {
    inherit version pname;
    sha256 = "0ny3v8x83mzpwmqjdzqhzy2pzwyy4wx01r1h9i29xw3yvas69m6k";
  };

  checkInputs = [
    pytest
    pytestpep8
    pytestcov
  ];

  checkPhase = ''
    pytest
  '';

  propagatedBuildInputs = [
    numpy
  ];

  meta = {
    description = "Optimizing NumPy's einsum function with order optimization and GPU support.";
    homepage = http://optimized-einsum.readthedocs.io;
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ teh ];
  };
}
