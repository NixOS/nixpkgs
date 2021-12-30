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
  version = "0.7.0";
  format = "setuptools";

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "danielperna84";
    repo = pname;
    rev = version;
    sha256 = "sha256-3qdA/s03mVek4KH+6wAvbPmpp3pSUWCmeOByNs48+MU=";
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
