{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pdm-backend,
  pdm-pep517,
  pytestCheckHook,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "jsonref";
  version = "1.1.0";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "gazpachoking";
    repo = "jsonref";
    rev = "refs/tags/v${version}";
    hash = "sha256-tOhabmqCkktJUZjCrzjOjUGgA/X6EVz0KqehyLtigfc=";
  };

  nativeBuildInputs = [
    pdm-backend
    pdm-pep517
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pytestFlagsArray = [ "tests.py" ];

  pythonImportsCheck = [ "jsonref" ];

  meta = with lib; {
    description = "Implementation of JSON Reference for Python";
    homepage = "https://github.com/gazpachoking/jsonref";
    changelog = "https://github.com/gazpachoking/jsonref/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
  };
}
