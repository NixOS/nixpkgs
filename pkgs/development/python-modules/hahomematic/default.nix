{ lib
, aiohttp
, buildPythonPackage
, fetchFromGitHub
, pydevccu
, pytest-aiohttp
, pytestCheckHook
, pythonOlder
, voluptuous
, websocket-client
, xmltodict
}:

buildPythonPackage rec {
  pname = "hahomematic";
  version = "0.12.0";
  format = "setuptools";

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "danielperna84";
    repo = pname;
    rev = version;
    sha256 = "sha256-A7fuTSrXMTK0oz87htylWKb868+YR7FXYYEC3hSgG7o=";
  };

  propagatedBuildInputs = [
    aiohttp
    voluptuous
  ];

  checkInputs = [
    pydevccu
    pytest-aiohttp
    pytestCheckHook
  ];

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
