{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  wheel,
  requests,
  typing-extensions,
}:

buildPythonPackage rec {
  pname = "kagiapi";
  version = "0.2.1";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-NV/kB7TGg9bwhIJ+T4VP2VE03yhC8V0Inaz/Yg4/Sus=";
  };

  build-system = [
    setuptools
    wheel
  ];

  dependencies = [
    requests
    typing-extensions
  ];

  pythonImportsCheck = [
    "kagiapi"
  ];

  meta = {
    description = "Python package for Kagi Search API";
    homepage = "https://pypi.org/project/kagiapi";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ etwas ];
    mainProgram = "kagiapi";
  };
}
