{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pyheck,
  pytestCheckHook,
  pythonOlder,
  setuptools,
}:

buildPythonPackage rec {
  pname = "dotwiz";
  version = "0.4.0";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "rnag";
    repo = "dotwiz";
    tag = "v${version}";
    hash = "sha256-ABmkwpJ40JceNJieW5bhg0gqWNrR6Wxj84nLCjKU11A=";
  };

  build-system = [ setuptools ];

  dependencies = [ pyheck ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "dotwiz" ];

  disabledTestPaths = [ "benchmarks" ];

  meta = with lib; {
    description = "Dict subclass that supports dot access notation";
    homepage = "https://github.com/rnag/dotwiz";
    changelog = "https://github.com/rnag/dotwiz/blob/v${src.tag}/HISTORY.rst";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
