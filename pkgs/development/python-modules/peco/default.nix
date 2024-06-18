{
  lib,
  aiohttp,
  buildPythonPackage,
  fetchPypi,
  pydantic,
  pythonOlder,
  setuptools,
}:

buildPythonPackage rec {
  pname = "peco";
  version = "0.0.30";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-a3MPqtbDftbLGtpJ66CFVC5wJFa9L3dqOKPfBZCaHpM=";
  };

  build-system = [ setuptools ];

  dependencies = [
    aiohttp
    pydantic
  ];

  # Module has no tests
  doCheck = false;

  pythonImportsCheck = [ "peco" ];

  meta = with lib; {
    description = "Library for interacting with the PECO outage map";
    homepage = "https://github.com/IceBotYT/peco-outage-api";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
