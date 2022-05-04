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
  version = "1.0.5";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "jeeftor";
    repo = pname;
    rev = version;
    hash = "sha256-wBk9tCVXDxHBnhofFQfMbsrYF4UYRZ2oXEBCldvJTnM=";
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
