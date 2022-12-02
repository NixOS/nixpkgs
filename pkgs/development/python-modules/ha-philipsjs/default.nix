{ lib
, buildPythonPackage
, cryptography
, fetchFromGitHub
, httpx
, pytest-aiohttp
, pytest-mock
, pytestCheckHook
, pythonOlder
, respx
}:

buildPythonPackage rec {
  pname = "ha-philipsjs";
  version = "2.9.0";
  format = "setuptools";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "danielperna84";
    repo = pname;
    rev = version;
    sha256 = "sha256-B2AQoVyoG6wyE9pTWf/ASQd8iZfIrjUr078rSkoARf0=";
  };

  propagatedBuildInputs = [
    cryptography
    httpx
  ];

  checkInputs = [
    pytest-aiohttp
    pytest-mock
    pytestCheckHook
    respx
  ];

  pythonImportsCheck = [
    "haphilipsjs"
  ];

  meta = with lib; {
    description = "Python library to interact with Philips TVs with jointSPACE API";
    homepage = "https://github.com/danielperna84/ha-philipsjs";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
