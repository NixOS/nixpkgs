{
  lib,
  aiohttp,
  aioresponses,
  buildPythonPackage,
  fetchFromGitHub,
  hatchling,
  mashumaro,
  pytest-asyncio,
  pytestCheckHook,
  pythonOlder,
  syrupy,
}:

buildPythonPackage rec {
  pname = "fyta-cli";
  version = "0.7.0";
  pyproject = true;

  disabled = pythonOlder "3.11";

  src = fetchFromGitHub {
    owner = "dontinelli";
    repo = "fyta_cli";
    rev = "refs/tags/v${version}";
    hash = "sha256-OgpQh7WyZynFd308TjIGkQNoy8TFu9gynbDiLueqB/0=";
  };

  build-system = [ hatchling ];

  dependencies = [
    aiohttp
    mashumaro
  ];

  nativeCheckInputs = [
    aioresponses
    pytest-asyncio
    pytestCheckHook
    syrupy
  ];

  pythonImportsCheck = [ "fyta_cli" ];

  pytestFlagsArray = [ "--snapshot-update" ];

  meta = with lib; {
    description = "Module to access the FYTA API";
    homepage = "https://github.com/dontinelli/fyta_cli";
    changelog = "https://github.com/dontinelli/fyta_cli/releases/tag/v${version}";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ fab ];
  };
}
