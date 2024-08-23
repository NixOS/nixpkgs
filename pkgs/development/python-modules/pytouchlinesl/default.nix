{
  aiohttp,
  buildPythonPackage,
  fetchFromGitHub,
  lib,
  nix-update-script,
  pydantic,
  pytest-asyncio,
  pytestCheckHook,
  pythonOlder,
  setuptools,
}:

buildPythonPackage rec {
  pname = "pytouchlinesl";
  version = "0.1.1";
  pyproject = true;

  disabled = pythonOlder "3.10";

  src = fetchFromGitHub {
    owner = "jnsgruk";
    repo = "pytouchlinesl";
    rev = "refs/tags/${version}";
    hash = "sha256-xyAy5QtNox1ZeXGQEYXWiEIQKSNQSnRTqr0kgQRmdcg=";
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

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "A Python API client for Roth's TouchlineSL API";
    homepage = "https://github.com/jnsgruk/pytouchlinesl";
    changelog = "https://github.com/jnsgruk/pytouchlinesl/releases/tag/${src.rev}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ jnsgruk ];
  };
}
