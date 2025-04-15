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
  version = "2.15.0";
  pyproject = true;

  disabled = pythonOlder "3.11";

  src = fetchFromGitHub {
    owner = "fredrike";
    repo = "pydaikin";
    tag = "v${version}";
    hash = "sha256-5WV+xY9L9Ht3OQ8GBMDq57L8qaT7DVaf7b4mnvicAL4=";
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
    changelog = "https://github.com/fredrike/pydaikin/releases/tag/${src.tag}";
    license = with licenses; [ gpl3Only ];
    maintainers = with maintainers; [ fab ];
    mainProgram = "pydaikin";
  };
}
