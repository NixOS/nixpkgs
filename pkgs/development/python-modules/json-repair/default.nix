{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "json-repair";
  version = "0.27.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "mangiucugna";
    repo = "json_repair";
    rev = "refs/tags/${version}";
    hash = "sha256-kaTwdS2zRt94pJko9AKEvszLR4z62u3ZrKlfXkJr5TQ=";
  };

  build-system = [ setuptools ];

  nativeBuildInputs = [ pytestCheckHook ];

  disabledTestPaths = [ "tests/test_performance.py" ];

  pythonImportsCheck = [ "json_repair" ];

  meta = with lib; {
    homepage = "https://github.com/mangiucugna/json_repair/";
    description = "repair invalid JSON, commonly used to parse the output of LLMs";
    license = licenses.mit;
    maintainers = with maintainers; [ greg ];
  };
}
