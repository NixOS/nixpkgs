{
  lib,
  aioresponses,
  buildPythonPackage,
  orjson,
  fetchFromGitHub,
  pytest-asyncio,
  pytestCheckHook,
  pythonOlder,
  aiohttp,
  setuptools,
}:

buildPythonPackage rec {
  pname = "nexia";
  version = "2.0.9";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "bdraco";
    repo = "nexia";
    tag = version;
    hash = "sha256-HbsjMugPFptRPCwvXszD7Zfyl0P/VfQRbVDSMC+4mcg=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace '"setuptools>=75.8.0"' ""
  '';

  build-system = [ setuptools ];

  dependencies = [
    orjson
    aiohttp
  ];

  nativeCheckInputs = [
    aioresponses
    pytest-asyncio
    pytestCheckHook
  ];

  pythonImportsCheck = [ "nexia" ];

  meta = with lib; {
    description = "Python module for Nexia thermostats";
    homepage = "https://github.com/bdraco/nexia";
    changelog = "https://github.com/bdraco/nexia/releases/tag/${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ fab ];
  };
}
