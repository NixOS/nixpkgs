{ lib
, aiohttp
, buildPythonPackage
, fetchPypi
, certifi
, pythonOlder
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "crownstone-cloud";
  version = "1.4.11";
  format = "setuptools";

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    pname = "crownstone_cloud";
    inherit version;
    hash = "sha256-s84pK52uMupxQfdMldV14V3nj+yVku1Vw13CRX4o08U=";
  };

  propagatedBuildInputs = [
    aiohttp
    certifi
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  postPatch = ''
    sed -i '/codecov/d' requirements.txt
  '';

  pythonImportsCheck = [
    "crownstone_cloud"
  ];

  meta = with lib; {
    description = "Python module for communicating with Crownstone Cloud and devices";
    homepage = "https://github.com/Crownstone-Community/crownstone-lib-python-cloud";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
