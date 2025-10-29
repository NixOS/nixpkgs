{
  buildPythonPackage,
  fetchPypi,
  setuptools,
  flit-core,
  apeye-core,
  domdf-python-tools,
  platformdirs,
  requests,
  lib,
}:
buildPythonPackage rec {
  pname = "apeye";
  version = "1.4.1";
  pyproject = true;

  src = fetchPypi {
    inherit version;
    pname = "apeye";
    hash = "sha256-FOpUL61onjv9vaIYmjVKSQjpCu5L+EwVq3XWhFPXajY=";
  };

  build-system = [ setuptools ];

  dependencies = [
    flit-core
    apeye-core
    domdf-python-tools
    platformdirs
    requests
  ];

  pythonImportsCheck = [ "apeye" ];

  pythonNamespaces = [ "apeye" ];

  meta = {
    description = "Handy tools for working with URLs and APIs.";
    homepage = "https://github.com/domdfcoding/apeye";
    license = lib.licenses.gpl3Plus;
  };
}
