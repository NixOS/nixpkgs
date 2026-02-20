{
  aiohttp,
  aresponses,
  buildPythonPackage,
  fetchFromGitHub,
  hatchling,
  lib,
  mashumaro,
  orjson,
  pytest-cov-stub,
  pytestCheckHook,
  syrupy,
  yarl,
}:

buildPythonPackage rec {
  pname = "pyfirefly";
  version = "0.1.13";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "erwindouna";
    repo = "pyfirefly";
    tag = "v${version}";
    hash = "sha256-h3p1uP8K/M2DNLapnBlaYmRcYDNzhqdx8507nm7ugqY=";
  };

  build-system = [ hatchling ];

  dependencies = [
    aiohttp
    mashumaro
    orjson
    yarl
  ];

  pythonImportsCheck = [ "pyfirefly" ];

  nativeCheckInputs = [
    aresponses
    pytest-cov-stub
    pytestCheckHook
    syrupy
  ];

  meta = {
    changelog = "https://github.com/erwindouna/pyfirefly/releases/tag/${src.tag}";
    description = "Asynchronous Python client for the Firefly III API";
    homepage = "https://github.com/erwindouna/pyfirefly";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.dotlambda ];
  };
}
