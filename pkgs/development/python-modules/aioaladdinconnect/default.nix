{ lib
, aiohttp
, buildPythonPackage
, fetchPypi
, pythonOlder
}:

buildPythonPackage rec {
  pname = "aioaladdinconnect";
  version = "0.1.25";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    pname = "AIOAladdinConnect";
    inherit version;
    hash = "sha256-ruuiRhPPqsZxJgaKVtwQK8Zf7gG9r2NYnrBCosTtL/M=";
  };

  propagatedBuildInputs = [
    aiohttp
  ];

  # Module has no tests
  doCheck = false;

  pythonImportsCheck = [
    "AIOAladdinConnect"
  ];

  meta = with lib; {
    description = "Library for controlling Genie garage doors connected to Aladdin Connect devices";
    homepage = "https://github.com/mkmer/AIOAladdinConnect";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
