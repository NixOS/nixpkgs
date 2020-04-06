{ buildPythonPackage, fetchPypi, lib, numpy, pytest_4 }:

buildPythonPackage rec {
  version = "3.1.0";
  pname = "opt_einsum";

  src = fetchPypi {
    inherit version pname;
    sha256 = "edfada4b1d0b3b782ace8bc14e80618ff629abf53143e1e6bbf9bd00b11ece77";
  };

  propagatedBuildInputs = [ numpy ];

  checkInputs = [ pytest_4 ];

  checkPhase = ''
    pytest
  '';

  meta = with lib; {
    description = "Optimizing NumPy's einsum function with order optimization and GPU support.";
    homepage = https://github.com/dgasmith/opt_einsum;
    license = licenses.mit;
    maintainers = with maintainers; [ teh ];
  };
}
