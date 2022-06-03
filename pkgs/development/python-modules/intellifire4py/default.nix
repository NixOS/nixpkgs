{ lib
, aenum
, aiohttp
, buildPythonPackage
, fetchFromGitHub
, pydantic
, pytestCheckHook
, pythonOlder
, requests
}:

buildPythonPackage rec {
  pname = "intellifire4py";
  version = "2.0.1";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "jeeftor";
    repo = pname;
    rev = version;
    hash = "sha256-CO6ImL2e6B2yvHAQs3Cc7oaOllB5V9sap4bQS/XRnWI=";
  };

  propagatedBuildInputs = [
    aenum
    aiohttp
    pydantic
    requests
  ];

  checkInputs = [
    pytestCheckHook
  ];

  disabledTests = [
    # Test file is missing
    "test_json_files"
  ];

  pythonImportsCheck = [
    "intellifire4py"
  ];

  meta = with lib; {
    description = "Module to read Intellifire fireplace status data";
    homepage = "https://github.com/jeeftor/intellifire4py";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
