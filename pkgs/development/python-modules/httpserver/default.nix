{ lib, fetchPypi, buildPythonPackage, docopt, pythonOlder }:

buildPythonPackage rec {
  pname = "httpserver";
  version = "1.1.0";
  format = "setuptools";

  buildInputs = [ docopt ];

  # Tests pull in lots of other dependencies to emulate different web
  # drivers.
  doCheck = false;

  # Because it uses asyncio
  disabled = pythonOlder "3.4";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1q62g324dvb0hqdwwrnj41sqr4d3ly78v9nc26rz1whj4pwdmhsv";
  };

  meta = {
    description = "Asyncio implementation of an HTTP server";
    homepage = "https://github.com/thomwiggers/httpserver";
    license = with lib.licenses; [ bsd3 ];
  };
}
