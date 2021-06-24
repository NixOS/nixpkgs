{ buildPythonPackage, fetchPypi, lib, numpy, pytest_4 }:

buildPythonPackage rec {
  version = "3.3.0";
  pname = "opt_einsum";

  src = fetchPypi {
    inherit version pname;
    sha256 = "0jb5lia0q742d1713jk33vlj41y61sf52j6pgk7pvhxvfxglgxjr";
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
