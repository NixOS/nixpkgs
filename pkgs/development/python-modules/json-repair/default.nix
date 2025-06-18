{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "json-repair";
  version = "0.46.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "mangiucugna";
    repo = "json_repair";
    tag = "v${version}";
    hash = "sha256-Xj3gLduN5aiy/XJ8jOaJEp4o3iX+PTD6eLBGHoHQ5HM=";
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
