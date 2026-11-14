{
  lib,
  aiohttp,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  setuptools,
}:

buildPythonPackage rec {
  pname = "agent-py";
  version = "0.0.25";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "ispysoftware";
    repo = "agent-py";
    tag = "agent-py.${version}";
    hash = "sha256-G7rmOl2H/xpOSVmjvZXLm8WBqn+aCgOzqz/yKy2huMY=";
  };

  build-system = [ setuptools ];

  dependencies = [ aiohttp ];

  doCheck = false; # only test is outdated

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "agent" ];

  meta = {
    description = "Python wrapper around the Agent REST API";
    homepage = "https://github.com/ispysoftware/agent-py";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ jamiemagee ];
  };
}
