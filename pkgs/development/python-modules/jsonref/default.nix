{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pdm-backend,
  pdm-pep517,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "jsonref";
  version = "1.1.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "gazpachoking";
    repo = "jsonref";
    tag = "v${version}";
    hash = "sha256-tOhabmqCkktJUZjCrzjOjUGgA/X6EVz0KqehyLtigfc=";
  };

  nativeBuildInputs = [
    pdm-backend
    pdm-pep517
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  enabledTestPaths = [ "tests.py" ];

  pythonImportsCheck = [ "jsonref" ];

  meta = {
    description = "Implementation of JSON Reference for Python";
    homepage = "https://github.com/gazpachoking/jsonref";
    changelog = "https://github.com/gazpachoking/jsonref/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
}
