{
  lib,
  aiohttp,
  aresponses,
  buildPythonPackage,
  fetchFromGitHub,
  mashumaro,
  orjson,
  poetry-core,
  pytest-asyncio,
  pytest-cov-stub,
  pytestCheckHook,
  syrupy,
  yarl,
}:

buildPythonPackage rec {
  pname = "powerfox";
  version = "2.0.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "klaasnicolaas";
    repo = "python-powerfox";
    tag = "v${version}";
    hash = "sha256-ygzO4/KZ9XUBjLVq48gvyZVEVRB1VJV6DpuHGKNXP54=";
  };

  build-system = [ poetry-core ];

  dependencies = [
    aiohttp
    mashumaro
    orjson
    yarl
  ];

  nativeCheckInputs = [
    aresponses
    pytest-asyncio
    pytest-cov-stub
    pytestCheckHook
    syrupy
  ];

  pythonImportsCheck = [ "powerfox" ];

  meta = {
    description = "Asynchronous Python client for the Powerfox devices";
    homepage = "https://github.com/klaasnicolaas/python-powerfox";
    changelog = "https://github.com/klaasnicolaas/python-powerfox/releases/tag/${src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
}
