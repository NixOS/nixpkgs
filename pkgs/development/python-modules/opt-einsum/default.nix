{ buildPythonPackage, fetchPypi, lib, numpy, pytest, pytestpep8, pytestcov }:
buildPythonPackage rec {
  version = "3.0.1";
  pname = "opt_einsum";

  src = fetchPypi {
    inherit version pname;
    sha256 = "1agyvq26x0zd6j3wzgczl4apx8v7cb9w1z50azn8c3pq9jphgfla";
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
