{
  aiohttp,
  buildPythonPackage,
  fetchFromGitHub,
  lib,
  setuptools,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "agent-py";
  version = "0.0.24";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "ispysoftware";
    repo = "agent-py";
    rev = "refs/tags/agent-py.${version}";
    hash = "sha256-PP4gQ3AFYLJPUt9jhhiV9HkfBhIzd+JIsGpgK6FNmaE=";
  };

  build-system = [ setuptools ];

  dependencies = [ aiohttp ];

  doCheck = false; # only test is outdated

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "agent" ];

  meta = with lib; {
    description = "Python wrapper around the Agent REST API";
    homepage = "https://github.com/ispysoftware/agent-py";
    license = licenses.asl20;
    maintainers = with maintainers; [ jamiemagee ];
  };
}
