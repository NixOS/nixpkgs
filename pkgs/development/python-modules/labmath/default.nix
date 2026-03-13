{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
}:

buildPythonPackage rec {
  pname = "labmath";
  version = "2.2.0";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-dzJ4szPxnck0Cgc5IEp5FBmHvIyAC0rqKRVrkt20ntQ=";
  };

  nativeBuildInputs = [ setuptools ];

  pythonImportsCheck = [ "labmath" ];

  meta = {
    homepage = "https://pypi.org/project/labmath";
    description = "Module for basic math in the general vicinity of computational number theory";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ siraben ];
  };
}
