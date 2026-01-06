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
  version = "0.5.0";
  pyproject = true;

  disabled = pythonOlder "3.10";

  src = fetchFromGitHub {
    owner = "jnsgruk";
    repo = "pytouchlinesl";
    tag = version;
    hash = "sha256-R5XgH8A9P5KcjQL/f+E189A+iRVUIbWsmyRrnfV43v4=";
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
    description = "Python API client for Roth's TouchlineSL API";
    homepage = "https://github.com/jnsgruk/pytouchlinesl";
    changelog = "https://github.com/jnsgruk/pytouchlinesl/releases/tag/${version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ jnsgruk ];
  };
}
