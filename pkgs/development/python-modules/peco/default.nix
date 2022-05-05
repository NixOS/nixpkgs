{ lib
, aiohttp
, buildPythonPackage
, fetchPypi
, pydantic
, pythonOlder
}:

buildPythonPackage rec {
  pname = "peco";
  version = "0.0.29";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-zL0tBTwm+l5eyxlWr2xoE+nLpMfUKri1/yD+WgTUqHQ=";
  };

  propagatedBuildInputs = [
    aiohttp
    pydantic
  ];

  # Module has no tests
  doCheck = false;

  pythonImportsCheck = [
    "peco"
  ];

  meta = with lib; {
    description = "Library for interacting with the PECO outage map";
    homepage = "https://github.com/IceBotYT/peco-outage-api";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
