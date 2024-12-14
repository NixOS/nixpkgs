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
  version = "0.6.10";
  pyproject = true;

  disabled = pythonOlder "3.11";

  src = fetchFromGitHub {
    owner = "dontinelli";
    repo = "fyta_cli";
    rev = "refs/tags/v${version}";
    hash = "sha256-sPbN6gMPtNzYTYQ5F8w59m5DKobx/TV6v5v8Q9u1rXQ=";
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
