{
  lib,
  buildPythonPackage,
  cryptography,
  email-validator,
  fetchPypi,
  flask,
  poetry-core,
  pythonOlder,
  pyjwt,
  requests,
}:

buildPythonPackage rec {
  pname = "descope";
  version = "1.7.11";
  pyproject = true;

  disabled = pythonOlder "3.8.1";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-x4JsBweG7d6htBqDUfAMfgatOD+a03F5Pxa9y/BEFjA=";
  };

  build-system = [ poetry-core ];

  dependencies = [
    cryptography
    email-validator
    pyjwt
    requests
  ];

  optional-dependencies = {
    flask = [ flask ];
  };

  pythonImportsCheck = [ "descope" ];

  # Package does not include tests in distribution
  doCheck = false;

  # Skip runtime dependency check - liccheck is a dev dependency
  dontCheckRuntimeDeps = true;

  meta = with lib; {
    description = "Descope Python SDK";
    homepage = "https://descope.com/";
    changelog = "https://github.com/descope/python-sdk/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
  };
}