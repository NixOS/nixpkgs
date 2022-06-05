{ lib
, aiohttp
, buildPythonPackage
, fetchFromGitHub
, furl
, jsonschema
, nose
, pytestCheckHook
, pythonOlder
, requests
, xmltodict
}:

buildPythonPackage rec {
  pname = "pook";
  version = "1.0.2";
  disabled = pythonOlder "3.5";

  src = fetchFromGitHub {
    owner = "h2non";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-4OGcnuajGdBRlXCYwbTK/zLNQRrir60qCYajHRRCpkU=";
  };

  propagatedBuildInputs = [
    aiohttp
    furl
    jsonschema
    requests
    xmltodict
  ];

  checkInputs = [
    nose
    pytestCheckHook
  ];

  pythonImportsCheck = [ "pook" ];

  meta = with lib; {
    description = "HTTP traffic mocking and testing made simple in Python";
    homepage = "https://github.com/h2non/pook";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
