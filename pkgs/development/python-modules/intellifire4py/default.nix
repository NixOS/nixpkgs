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
  version = "2.2.1";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "jeeftor";
    repo = pname;
    rev = version;
    hash = "sha256-dn5814eRZ9456Fn7blf1UzXPii4dXu3sjoXBV7CmwSs=";
  };

  propagatedBuildInputs = [
    aenum
    aiohttp
    pydantic
    requests
  ];

  checkInputs = [
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
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
