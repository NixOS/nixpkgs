{
  lib,
  buildPythonPackage,
  fetchPypi,
  pythonOlder,
  poetry-core,
  importlib-metadata,
  importlib-resources,
}:

buildPythonPackage rec {
  pname = "cmudict";
  version = "1.1.2";
  pyproject = true;

  disabled = pythonOlder "3.9";
  src = fetchPypi {
    inherit pname version;
    hash = "sha256-IhZd73NPGpwZHKFowGbX6lgsi42nkNo+g0TpZeJkfbg=";
  };

  build-system = [
    poetry-core
  ];

  dependencies = [
    importlib-metadata
    importlib-resources
  ];

  pythonImportsCheck = [
    "cmudict"
  ];

  meta = {
    changelog = "https://github.com/prosegrinder/python-cmudict/blob/main/CHANGELOG.md";
    description = "A versioned python wrapper package for The CMU Pronouncing Dictionary data files";
    homepage = "https://pypi.org/project/cmudict/";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ sandarukasa ];
  };
}
