{ lib
, aiohttp
, buildPythonPackage
, fetchPypi
, pythonOlder
}:

buildPythonPackage rec {
  pname = "aioaladdinconnect";
  version = "0.1.45";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    pname = "AIOAladdinConnect";
    inherit version;
    hash = "sha256-Fc34DPhN27wzEGSkRSpynqi9EGw1r3Iwp5rtT4eMMBI=";
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
