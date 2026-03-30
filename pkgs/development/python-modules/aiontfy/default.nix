{
  aiohttp,
  buildPythonPackage,
  fetchFromGitHub,
  hatch-regex-commit,
  hatchling,
  lib,
  mashumaro,
  orjson,
  pytest-asyncio,
  pytest-cov-stub,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "aiontfy";
  version = "0.8.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "tr4nt0r";
    repo = "aiontfy";
    tag = "v${version}";
    hash = "sha256-whofQUPT4UcOOBxvdMz3mMzMR/svVaLQrC6c7EfzwZY=";
  };

  build-system = [
    hatch-regex-commit
    hatchling
  ];

  pythonRelaxDeps = [
    "orjson"
  ];

  dependencies = [
    aiohttp
    mashumaro
    orjson
  ];

  pythonImportsCheck = [ "aiontfy" ];

  nativeCheckInputs = [
    pytest-asyncio
    pytest-cov-stub
    pytestCheckHook
  ];

  meta = {
    changelog = "https://github.com/tr4nt0r/aiontfy/releases/tag/${src.tag}";
    description = "Async ntfy client library";
    homepage = "https://github.com/tr4nt0r/aiontfy";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
}
