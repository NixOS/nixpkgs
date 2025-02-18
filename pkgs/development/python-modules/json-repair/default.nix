{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "json-repair";
  version = "0.35.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "mangiucugna";
    repo = "json_repair";
    tag = "v${version}";
    hash = "sha256-39MxXX3bBYLmpaUpNYLWq+8Huoy0zQSyURQiZvXFaZc=";
  };

  build-system = [ setuptools ];

  nativeCheckInputs = [ pytestCheckHook ];

  disabledTestPaths = [
    "tests/test_performance.py"
    "tests/test_coverage.py"
  ];

  pythonImportsCheck = [ "json_repair" ];

  meta = with lib; {
    description = "Module to repair invalid JSON, commonly used to parse the output of LLMs";
    homepage = "https://github.com/mangiucugna/json_repair/";
    changelog = "https://github.com/mangiucugna/json_repair/releases/tag/${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ greg ];
  };
}
