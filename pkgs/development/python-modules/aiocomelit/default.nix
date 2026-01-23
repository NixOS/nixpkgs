{
  lib,
  aiohttp,
  buildPythonPackage,
  colorlog,
  fetchFromGitHub,
  pint,
  poetry-core,
  pytest-cov-stub,
  pytestCheckHook,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "aiocomelit";
  version = "2.0.0";
  pyproject = true;

  disabled = pythonOlder "3.12";

  src = fetchFromGitHub {
    owner = "chemelli74";
    repo = "aiocomelit";
    tag = "v${version}";
    hash = "sha256-gk/WYeSl+962Nd0V3VQOy1aYDaSH82qjW1VU2siqU98=";
  };

  build-system = [ poetry-core ];

  dependencies = [
    aiohttp
    colorlog
    pint
  ];

  nativeCheckInputs = [
    pytest-cov-stub
    pytestCheckHook
  ];

  pythonImportsCheck = [ "aiocomelit" ];

  meta = {
    description = "Library to control Comelit Simplehome";
    homepage = "https://github.com/chemelli74/aiocomelit";
    changelog = "https://github.com/chemelli74/aiocomelit/blob/${src.tag}/CHANGELOG.md";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ fab ];
  };
}
