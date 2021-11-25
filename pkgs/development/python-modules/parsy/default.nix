{ lib, buildPythonPackage, fetchPypi, pythonOlder, pytest }:

buildPythonPackage rec {
  pname = "parsy";
  version = "1.4.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "7c411373e520e97431f0b390db9d2cfc5089bc1d33f4f1584d2cdc9e6368f302";
  };

  checkInputs = [ pytest ];

  checkPhase = ''
    py.test test/
  '';

  disabled = pythonOlder "3.4";

  meta = with lib; {
    homepage = "https://github.com/python-parsy/parsy";
    description = "Easy-to-use parser combinators, for parsing in pure Python";
    license = [ licenses.mit ];
    maintainers = with maintainers; [ edibopp ];
  };
}
