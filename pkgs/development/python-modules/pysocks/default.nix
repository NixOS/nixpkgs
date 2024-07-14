{
  lib,
  buildPythonPackage,
  fetchPypi,
}:

buildPythonPackage rec {
  pname = "pysocks";
  version = "1.7.1";
  format = "setuptools";

  src = fetchPypi {
    pname = "PySocks";
    inherit version;
    hash = "sha256-P4gEVx6+FZw4CsbeN2Q7tGhZcGVdO7okNTDWVYt5mqA=";
  };

  doCheck = false;

  meta = with lib; {
    description = "SOCKS module for Python";
    license = licenses.bsd3;
    maintainers = with maintainers; [ thoughtpolice ];
  };
}
