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
  version = "1.1.1";
  format = "setuptools";
  disabled = pythonOlder "3.5";

  src = fetchFromGitHub {
    owner = "h2non";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-nLeJAAsJUKFAetZSAQmOtXP+3ZRHvCTFAzycSkK+kiI=";
  };

  propagatedBuildInputs = [
    aiohttp
    furl
    jsonschema
    requests
    xmltodict
  ];

  nativeCheckInputs = [
    nose
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "pook"
  ];

  meta = with lib; {
    description = "HTTP traffic mocking and testing made simple in Python";
    homepage = "https://github.com/h2non/pook";
    changelog = "https://github.com/h2non/pook/blob/v${version}/History.rst";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
