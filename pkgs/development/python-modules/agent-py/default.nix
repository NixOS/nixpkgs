{
  aiohttp,
  buildPythonPackage,
  fetchFromGitHub,
  fetchpatch,
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
    tag = "agent-py.${version}";
    hash = "sha256-PP4gQ3AFYLJPUt9jhhiV9HkfBhIzd+JIsGpgK6FNmaE=";
  };

  patches = [
    # https://github.com/ispysoftware/agent-py/pull/4
    (fetchpatch {
      name = "replace-async-timeout-with-asyncio.timeout.patch";
      url = "https://github.com/ispysoftware/agent-py/commit/2d7bcf46dce9bc733ce243858f0e91ced512c72d.patch";
      hash = "sha256-G/C/e/F+xtUH+2a7mNhhKONqVjYvLHt5/I75WGafl0w=";
    })
  ];

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
