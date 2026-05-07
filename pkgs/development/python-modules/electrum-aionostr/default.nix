{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  aiohttp,
  aiohttp-socks,
  aiorpcx,
  cryptography,
  electrum-ecc,
  click,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "electrum-aionostr";
  version = "0.1.0";
  pyproject = true;
  build-system = [ setuptools ];

  src = fetchPypi {
    pname = "electrum_aionostr";
    inherit version;
    hash = "sha256-N3T46DEjiCcuEIUahpyfTT1KVNjVZIUcNuLcQCl77IQ=";
  };

  dependencies = [
    aiohttp
    aiohttp-socks
    aiorpcx
    cryptography
    electrum-ecc
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  checkInputs = [ click ];

  pythonImportsCheck = [ "electrum_aionostr" ];

  disabledTests = [
    # command line interface is broken
    "test_command_line_interface"
  ];

  meta = {
    description = "Asyncio nostr client";
    homepage = "https://github.com/spesmilo/electrum-aionostr";
    license = lib.licenses.bsd3;
    maintainers = [ ];
  };
}
