{ lib
, buildPythonPackage
, dvc-render
, fetchFromGitHub
, pytestCheckHook
, pythonOlder
, ruamel-yaml
, setuptools
, tabulate
}:

buildPythonPackage rec {
  pname = "dvclive";
  version = "1.3.0";
  format = "pyproject";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "iterative";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-FAupTvaOLPp5EQ0vvE8tQCa8WnKW/qrQTc7i+6F7F1A=";
  };

  nativeBuildInputs = [
    setuptools
  ];

  propagatedBuildInputs = [
    dvc-render
    ruamel-yaml
  ] ++ dvc-render.optional-dependencies.table;

  # Circular dependency with dvc
  doCheck = false;

  pythonImportsCheck = [
    "dvclive"
  ];

  meta = with lib; {
    description = "Library for logging machine learning metrics and other metadata in simple file formats";
    homepage = "https://github.com/iterative/dvclive";
    changelog = "https://github.com/iterative/dvclive/releases/tag/${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ fab ];
  };
}
