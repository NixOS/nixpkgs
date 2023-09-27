{ lib
, aenum
, buildPythonPackage
, fetchFromGitHub
, httpx
, poetry-core
, pydantic
, pytest-httpx
, pytest-mock
, pytestCheckHook
, pythonOlder
, requests
}:

buildPythonPackage rec {
  pname = "intellifire4py";
  version = "3.1.10";
  pyproject = true;

  disabled = pythonOlder "3.11";

  src = fetchFromGitHub {
    owner = "jeeftor";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-++xmUvPDC6aq1ZzsFrUXevhwVekJZ8bcJVZg/J5S3Mk=";
  };

  nativeBuildInputs = [
    poetry-core
  ];

  propagatedBuildInputs = [
    aenum
    httpx
    pydantic
    requests
  ];

  nativeCheckInputs = [
    pytest-httpx
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
    changelog = "https://github.com/jeeftor/intellifire4py/releases/tag/v${version}";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
