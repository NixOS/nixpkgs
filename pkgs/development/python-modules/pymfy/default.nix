{ lib
, buildPythonPackage
, fetchFromGitHub
, httpretty
, poetry-core
, pytestCheckHook
, pythonOlder
, requests
, requests_oauthlib
}:

buildPythonPackage rec {
  pname = "pymfy";
  version = "0.10.1";
  format = "pyproject";
  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "tetienne";
    repo = "somfy-open-api";
    rev = "v${version}";
    sha256 = "sha256-xX7vNBQaYPdnsukFcQyEa2G1XIvf9ehADNXbLUUCRoU=";
  };

  nativeBuildInputs = [ poetry-core ];

  propagatedBuildInputs = [
    requests
    requests_oauthlib
  ];

  checkInputs = [
    httpretty
    pytestCheckHook
  ];

  pythonImportsCheck = [ "pymfy" ];

  meta = with lib; {
    description = "Python client for the Somfy Open API";
    homepage = "https://github.com/tetienne/somfy-open-api";
    license = with licenses; [ gpl3Only ];
    maintainers = with maintainers; [ fab ];
  };
}
