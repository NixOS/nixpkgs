{
  lib,
  aiohttp,
  aioresponses,
  buildPythonPackage,
  fetchFromGitHub,
  poetry-core,
  poetry-dynamic-versioning,
  pyjwt,
  pytest-aiohttp,
  pytest-freezegun,
  pytestCheckHook,
  pythonOlder,
  deepdiff,
}:

buildPythonPackage rec {
  pname = "pylitterbot";
  version = "2023.5.0";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "natekspencer";
    repo = "pylitterbot";
    rev = "refs/tags/v${version}";
    hash = "sha256-MSQdX2PKQohmPGqtRZnUmCCVgKgaf4+cHAUItiPv7pY=";
  };

  build-system = [
    poetry-core
    poetry-dynamic-versioning
  ];

  dependencies = [
    aiohttp
    deepdiff
    pyjwt
  ];

  nativeCheckInputs = [
    aioresponses
    pytest-aiohttp
    pytest-freezegun
    pytestCheckHook
  ];

  pythonImportsCheck = [ "pylitterbot" ];

  meta = with lib; {
    description = "Modulefor controlling a Litter-Robot";
    homepage = "https://github.com/natekspencer/pylitterbot";
    changelog = "https://github.com/natekspencer/pylitterbot/releases/tag/v${version}";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
