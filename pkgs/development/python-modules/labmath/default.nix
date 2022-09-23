{ lib, buildPythonPackage, fetchPypi }:

buildPythonPackage rec {
  pname = "labmath";
  version = "2.2.0";
  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-dzJ4szPxnck0Cgc5IEp5FBmHvIyAC0rqKRVrkt20ntQ=";
  };

  pythonImportsCheck = [ "labmath" ];

  meta = with lib; {
    homepage = "https://pypi.org/project/labmath";
    description = "Module for basic math in the general vicinity of computational number theory";
    license = licenses.mit;
    maintainers = with maintainers; [ siraben ];
  };
}
