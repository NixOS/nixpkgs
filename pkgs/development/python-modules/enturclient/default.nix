{
  lib,
  aiohttp,
  async-timeout,
  buildPythonPackage,
  fetchFromGitHub,
  poetry-core,
  pythonOlder,
  unittestCheckHook,
}:

buildPythonPackage rec {
  pname = "enturclient";
  version = "0.2.4";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "hfurubotten";
    repo = "enturclient";
    rev = "v${version}";
    hash = "sha256-Y2sBPikCAxumylP1LUy8XgjBRCWaNryn5XHSrRjJIIo=";
  };

  build-system = [ poetry-core ];

  dependencies = [
    aiohttp
    async-timeout
  ];

  pythonRelaxDeps = [
    "async_timeout"
  ];

  pythonImportsCheck = [ "enturclient" ];

  nativeCheckInputs = [
    unittestCheckHook
  ];

  unittestFlagsArray = [
    "tests/dto/"
  ];

  meta = with lib; {
    description = "Python library for interacting with the Entur.org API";
    homepage = "https://github.com/hfurubotten/enturclient";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
