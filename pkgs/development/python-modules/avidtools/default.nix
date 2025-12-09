{
  lib,
  buildPythonPackage,
  fetchPypi,
  nvdlib,
  poetry-core,
  pydantic,
  pythonOlder,
  typing-extensions,
}:

buildPythonPackage rec {
  pname = "avidtools";
  version = "0.2.1";
  pyproject = true;

  disabled = pythonOlder "3.12";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-rYkA/+YfFhrS/WSx+jUWCsXDjp03aMoMiGdXeK3Kf4M=";
  };

  build-system = [ poetry-core ];

  dependencies = [
    nvdlib
    pydantic
    typing-extensions
  ];

  # Module has no tests
  doCheck = false;

  pythonImportsCheck = [ "avidtools" ];

  meta = with lib; {
    description = "Developer tools for AVID";
    homepage = "https://github.com/avidml/avidtools";
    changelog = "https://github.com/avidml/avidtools/releases/tag/${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ fab ];
  };
}
