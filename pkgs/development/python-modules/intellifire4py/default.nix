{ lib
, aenum
, aiohttp
, asynctest
, buildPythonPackage
, fetchFromGitHub
, pydantic
, pytest-mock
, pytestCheckHook
, pythonOlder
, requests
}:

buildPythonPackage rec {
  pname = "intellifire4py";
  version = "2.2.2";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "jeeftor";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-iqlKfpnETLqQwy5sNcK2x/TgmuN2hCfYoHEFK2WWVXI=";
  };

  propagatedBuildInputs = [
    aenum
    aiohttp
    pydantic
    requests
  ];

  nativeCheckInputs = [
    asynctest
    pytest-mock
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
    changelog = "https://github.com/jeeftor/intellifire4py/blob/${version}/CHANGELOG";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
