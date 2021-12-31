{ lib
, buildPythonPackage
, fetchFromGitHub
, aiohttp
, pythonOlder
, voluptuous
, websocket-client
, xmltodict
}:

buildPythonPackage rec {
  pname = "hahomematic";
  version = "0.9.0";
  format = "setuptools";

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "danielperna84";
    repo = pname;
    rev = version;
    sha256 = "sha256-Tp8m5Kw+mubJXKgov+CbfwtzWYzmqyjK1Q9gRkivTxk=";
  };

  propagatedBuildInputs = [
    aiohttp
    voluptuous
  ];

  # Module has no tests
  doCheck = false;

  pythonImportsCheck = [
    "hahomematic"
  ];

  meta = with lib; {
    description = "Python module to interact with HomeMatic devices";
    homepage = "https://github.com/danielperna84/hahomematic";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
