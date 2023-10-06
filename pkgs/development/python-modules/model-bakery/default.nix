{ lib
, buildPythonPackage
, fetchFromGitHub
, hatchling
, django
, pytestCheckHook
, pythonOlder
, pytest-django
}:

buildPythonPackage rec {
  pname = "model-bakery";
  version = "1.15.0";
  format = "pyproject";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "model-bakers";
    repo = "model_bakery";
    rev = "refs/tags/${version}";
    hash = "sha256-gB6lcLymkajRoeOQ70kmZVlBI7oeZgQo1VySfPGeQLQ=";
  };

  nativeBuildInputs = [
    hatchling
  ];

  propagatedBuildInputs = [
    django
  ];

  nativeCheckInputs = [
    pytest-django
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "model_bakery"
  ];

  meta = with lib; {
    description = "Object factory for Django";
    homepage = "https://github.com/model-bakers/model_bakery";
    changelog = "https://github.com/model-bakers/model_bakery/blob/${version}/CHANGELOG.md";
    license = licenses.asl20;
    maintainers = with maintainers; [ fab ];
  };
}
