{
  lib,
  aiohttp,
  aresponses,
  buildPythonPackage,
  fetchFromGitHub,
  freezegun,
  netifaces,
  pytest-asyncio,
  pytestCheckHook,
  pythonOlder,
  urllib3,
  setuptools,
  tenacity,
}:

buildPythonPackage rec {
  pname = "pydaikin";
  version = "2.14.0";
  pyproject = true;

  disabled = pythonOlder "3.11";

  src = fetchFromGitHub {
    owner = "fredrike";
    repo = "pydaikin";
    tag = "v${version}";
    hash = "sha256-5qkJjGfVoNVHHmr77aWajpYmyfmV/ZyO3tXY9/gj6eU=";
  };

  __darwinAllowLocalNetworking = true;

  build-system = [ setuptools ];

  dependencies = [
    aiohttp
    netifaces
    urllib3
    tenacity
  ];

  nativeCheckInputs = [
    aresponses
    freezegun
    pytest-asyncio
    pytestCheckHook
  ];

  pythonImportsCheck = [ "pydaikin" ];

  meta = with lib; {
    description = "Python Daikin HVAC appliances interface";
    homepage = "https://github.com/fredrike/pydaikin";
    changelog = "https://github.com/fredrike/pydaikin/releases/tag/v${version}";
    license = with licenses; [ gpl3Only ];
    maintainers = with maintainers; [ fab ];
    mainProgram = "pydaikin";
  };
}
