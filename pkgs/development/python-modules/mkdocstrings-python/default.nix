{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  griffe,
  mkdocs-material,
  mkdocstrings,
  pdm-backend,
  pytestCheckHook,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "mkdocstrings-python";
  version = "1.10.3";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "mkdocstrings";
    repo = "python";
    rev = "refs/tags/${version}";
    hash = "sha256-OiG/dPsWO2Z4lGUlgPePRcsrotCu+fwesKhhh6YjmnU=";
  };

  build-system = [ pdm-backend ];

  dependencies = [
    griffe
    mkdocstrings
  ];

  nativeCheckInputs = [
    mkdocs-material
    pytestCheckHook
  ];

  pythonImportsCheck = [ "mkdocstrings_handlers" ];

  meta = with lib; {
    description = "Python handler for mkdocstrings";
    homepage = "https://github.com/mkdocstrings/python";
    changelog = "https://github.com/mkdocstrings/python/blob/${version}/CHANGELOG.md";
    license = licenses.isc;
    maintainers = with maintainers; [ fab ];
  };
}
