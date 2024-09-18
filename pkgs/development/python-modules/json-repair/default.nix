{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "json-repair";
  version = "0.27.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "mangiucugna";
    repo = "json_repair";
    rev = "refs/tags/${version}";
    hash = "sha256-NYY76sIp4XirVifOPOs6iEzP93ERzNIHAvpgU4+fi24=";
  };

  build-system = [ setuptools ];

  nativeBuildInputs = [ pytestCheckHook ];

  disabledTestPaths = [ "tests/test_performance.py" ];

  pythonImportsCheck = [ "json_repair" ];

  meta = with lib; {
    description = "Module to repair invalid JSON, commonly used to parse the output of LLMs";
    homepage = "https://github.com/mangiucugna/json_repair/";
    changelog = "https://github.com/mangiucugna/json_repair/releases/tag/${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ greg ];
  };
}
