{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "json-repair";
  version = "0.26.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "mangiucugna";
    repo = "json_repair";
    rev = "refs/tags/${version}";
    hash = "sha256-s28p7fmrQwZTiWJnTQjjR4vABNOaiW2ngkyfHgOzczQ=";
  };

  build-system = [ setuptools ];

  nativeBuildInputs = [ pytestCheckHook ];

  disabledTestPaths = [ "tests/test_performance.py" ];

  meta = with lib; {
    homepage = "https://github.com/mangiucugna/json_repair/";
    description = "repair invalid JSON, commonly used to parse the output of LLMs";
    license = licenses.mit;
    maintainers = with maintainers; [ greg ];
  };
}
