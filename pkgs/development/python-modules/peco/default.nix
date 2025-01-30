{
  lib,
  aiohttp,
  buildPythonPackage,
  fetchPypi,
  poetry-core,
  pydantic,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "peco";
  version = "0.1.2";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-xW65tEL86ecOfGIbnGiSnKtq7SmKQxW2eMTVrs/nxNc=";
  };

  build-system = [ poetry-core ];

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
    changelog = "https://github.com/IceBotYT/peco-outage-api/releases/tag/${version}";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
