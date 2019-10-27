{ buildPythonPackage, fetchPypi, lib, numpy, pytest_4 }:

buildPythonPackage rec {
  version = "3.0.1";
  pname = "opt_einsum";

  src = fetchPypi {
    inherit version pname;
    sha256 = "1agyvq26x0zd6j3wzgczl4apx8v7cb9w1z50azn8c3pq9jphgfla";
  };

  propagatedBuildInputs = [ numpy ];

  checkInputs = [ pytest_4 ];

  checkPhase = ''
    pytest
  '';

  meta = with lib; {
    description = "Optimizing NumPy's einsum function with order optimization and GPU support.";
    homepage = http://optimized-einsum.readthedocs.io;
    license = licenses.mit;
    maintainers = with maintainers; [ teh ];
  };
}
