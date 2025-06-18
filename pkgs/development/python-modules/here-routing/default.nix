{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  hatchling,
  aiohttp,
  async-timeout,
  yarl,
  aresponses,
  pytest-asyncio,
  pytest-cov-stub,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "here-routing";
  version = "1.1.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "eifinger";
    repo = "here_routing";
    tag = "v${version}";
    hash = "sha256-56Sx8pbfsuCj7mqG15HK3QoGGiQDFFrbkOdNedV+HY4=";
  };

  build-system = [ hatchling ];

  dependencies = [
    aiohttp
    async-timeout
    yarl
  ];

  nativeCheckInputs = [
    aresponses
    pytest-asyncio
    pytest-cov-stub
    pytestCheckHook
  ];

  pythonImportsCheck = [ "here_routing" ];

  meta = {
    changelog = "https://github.com/eifinger/here_routing/releases/tag/${src.tag}";
    description = "Asynchronous Python client for the HERE Routing V8 API";
    homepage = "https://github.com/eifinger/here_routing";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
}
