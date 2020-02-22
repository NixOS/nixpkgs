{ lib, buildPythonPackage, fetchPypi, pythonOlder, pytest }:

buildPythonPackage rec {
  pname = "parsy";
  version = "1.3.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "bfc941ea5a69e6ac16bd4f7d9f807bbc17e35edd8b95bcd2499a25b059359012";
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
