{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "json-repair";
  version = "0.50.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "mangiucugna";
    repo = "json_repair";
    tag = "v${version}";
    hash = "sha256-QiM5EVIJtnS4jE8aIm3dDi2LrF+eb2PoP02Qc/1tzzk=";
  };

  build-system = [ setuptools ];

  nativeCheckInputs = [ pytestCheckHook ];

  disabledTestPaths = [
    "tests/test_performance.py"
  ];

  pythonImportsCheck = [ "json_repair" ];

  meta = with lib; {
    description = "Module to repair invalid JSON, commonly used to parse the output of LLMs";
    homepage = "https://github.com/mangiucugna/json_repair/";
    changelog = "https://github.com/mangiucugna/json_repair/releases/tag/${src.tag}";
    license = licenses.mit;
    maintainers = with maintainers; [ greg ];
  };
}
