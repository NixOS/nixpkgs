{
  aiohttp,
  aresponses,
  buildPythonPackage,
  fetchFromGitHub,
  lib,
  mashumaro,
  orjson,
  poetry-core,
  pytest-cov-stub,
  pytestCheckHook,
  syrupy,
  yarl,
}:

buildPythonPackage rec {
  pname = "pyfirefly";
  version = "0.1.12";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "erwindouna";
    repo = "pyfirefly";
    tag = "v${version}";
    hash = "sha256-SCB05cKEZ4uejl81TUjz4qN0lzYuIKR1CgMbCsA+G4E=";
  };

  build-system = [ poetry-core ];

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
