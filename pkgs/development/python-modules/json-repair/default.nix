{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "json-repair";
  version = "0.29.6";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "mangiucugna";
    repo = "json_repair";
    rev = "refs/tags/v${version}";
    hash = "sha256-EP8uaH9vbpbgWtQTm+c2mbO2h1t6aK1ENpVw/Dkx2/U=";
  };

  build-system = [ setuptools ];

  nativeBuildInputs = [ pytestCheckHook ];

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
