{ lib
, buildPythonPackage
, fetchFromGitHub
, jsonschema
, pytestCheckHook
, pythonOlder
, requests
, setuptools
}:

buildPythonPackage rec {
  pname = "oras";
  version = "0.1.28";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "oras-project";
    repo = "oras-py";
    rev = "refs/tags/${version}";
    hash = "sha256-yka4TypKqGczW+NugmCGa8PgtaSJeaQ4sPphPsIPLow=";
  };

  nativeBuildInputs = [
    setuptools
  ];

  propagatedBuildInputs = [
    jsonschema
    requests
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "oras"
  ];

  disabledTests = [
    # Test requires network access
    "test_get_many_tags"
  ];

  meta = with lib; {
    description = "ORAS Python SDK";
    homepage = "https://github.com/oras-project/oras-py";
    changelog = "https://github.com/oras-project/oras-py/blob/${version}/CHANGELOG.md";
    license = licenses.asl20;
    maintainers = with maintainers; [ fab ];
  };
}
