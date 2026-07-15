{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  hatchling,
}:
buildPythonPackage rec {
  pname = "dataclass-csv";
  version = "1.4.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "dfurtado";
    repo = "dataclass-csv";
    tag = version;
    hash = "sha256-hDnuPg5xniybR2J91KnJxSlOI+dWzUPQJtYKfqsNCvw=";
  };

  build-system = [
    hatchling
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [ "dataclass_csv" ];

  meta = {
    description = "Map CSV data into dataclasses";
    homepage = "https://github.com/dfurtado/dataclass-csv";
    changelog = "https://github.com/dfurtado/dataclass-csv/releases/tag/${version}";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ theobori ];
  };
}
