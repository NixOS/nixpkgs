{ buildPythonPackage, fetchPypi, lib, numpy, pytest_4 }:

buildPythonPackage rec {
  version = "3.2.1";
  pname = "opt_einsum";

  src = fetchPypi {
    inherit version pname;
    sha256 = "165r7rsl5j94kna4q3vsaq71z23lgxd9b20dgb6abrlas6c6mdw3";
  };

  propagatedBuildInputs = [ numpy ];

  checkInputs = [ pytest_4 ];

  checkPhase = ''
    pytest
  '';

  meta = with lib; {
    description = "Optimizing NumPy's einsum function with order optimization and GPU support.";
    homepage = "https://github.com/dgasmith/opt_einsum";
    license = licenses.mit;
    maintainers = with maintainers; [ teh ];
  };
}
