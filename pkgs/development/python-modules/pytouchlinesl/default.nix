{
  aiohttp,
  buildPythonPackage,
  fetchFromGitHub,
  lib,
  pydantic,
  pytest-asyncio,
  pytestCheckHook,
  pythonOlder,
  setuptools,
}:

buildPythonPackage rec {
  pname = "pytouchlinesl";
  version = "0.1.7";
  pyproject = true;

  disabled = pythonOlder "3.10";

  src = fetchFromGitHub {
    owner = "jnsgruk";
    repo = "pytouchlinesl";
    rev = "refs/tags/${version}";
    hash = "sha256-Xth1zC08SIL8j7t2n64I4cyLd6UQABoSeg57tYhnvtE=";
  };

  build-system = [ setuptools ];

  dependencies = [
    aiohttp
    pydantic
  ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-asyncio
  ];

  pythonImportsCheck = [ "pytouchlinesl" ];

  meta = {
    description = "A Python API client for Roth's TouchlineSL API";
    homepage = "https://github.com/jnsgruk/pytouchlinesl";
    changelog = "https://github.com/jnsgruk/pytouchlinesl/releases/tag/${lib.removePrefix "refs/tags/" src.rev}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ jnsgruk ];
  };
}
