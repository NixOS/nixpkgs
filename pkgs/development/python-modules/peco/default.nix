{
  lib,
  aiohttp,
  buildPythonPackage,
  fetchPypi,
  poetry-core,
  pydantic,
}:

buildPythonPackage rec {
  pname = "peco";
  version = "0.1.2";
  pyproject = true;

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

  meta = {
    description = "Library for interacting with the PECO outage map";
    homepage = "https://github.com/IceBotYT/peco-outage-api";
    changelog = "https://github.com/IceBotYT/peco-outage-api/releases/tag/${version}";
    license = with lib.licenses; [ mit ];
    maintainers = with lib.maintainers; [ fab ];
  };
}
