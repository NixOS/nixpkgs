{ lib, buildPythonPackage, fetchPypi, isPyPy, isPy3k, click, gmpy2, numpy } :

let
  pname = "phe";
  version = "1.5.0";
in

buildPythonPackage {
  inherit pname version;

  # https://github.com/n1analytics/python-paillier/issues/51
  disabled = isPyPy || ! isPy3k;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-mS+3CR0kJ/DZczlG+PNQrN1NHQEgV/Kq02S6eflwM5w=";
  };

  buildInputs = [ click gmpy2 numpy ];

  # 29/233 tests fail
  doCheck = false;

  meta = with lib; {
    description = "A library for Partially Homomorphic Encryption in Python";
    homepage = "https://github.com/n1analytics/python-paillier";
    license = licenses.gpl3;
  };
}
