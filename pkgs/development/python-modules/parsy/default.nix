{ lib, buildPythonPackage, fetchPypi, pythonOlder, pytest }:

buildPythonPackage rec {
  pname = "parsy";
  version = "1.2.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0mdqg07x5ybmbmj55x75gyhfcjrn7ml0cf3z0jwbskx845j31m6x";
  };

  checkInputs = [ pytest ];

  checkPhase = ''
    py.test test/
  '';

  disabled = pythonOlder "3.4";

  meta = with lib; {
    homepage = https://github.com/python-parsy/parsy;
    description = "Easy-to-use parser combinators, for parsing in pure Python";
    license = [ licenses.mit ];
    maintainers = with maintainers; [ aepsil0n ];
  };
}
