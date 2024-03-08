{ lib
, buildPythonPackage
, dissect-cstruct
, dissect-util
, fetchFromGitHub
, setuptools
, setuptools-scm
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "dissect-etl";
  version = "3.8";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "fox-it";
    repo = "dissect.etl";
    rev = "refs/tags/${version}";
    hash = "sha256-yGpDZAaw11Sr5OPWxbY/NpZAV3jJUIgtTgDykCvYDtM=";
  };

  nativeBuildInputs = [
    setuptools
    setuptools-scm
  ];

  propagatedBuildInputs = [
    dissect-cstruct
    dissect-util
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "dissect.etl"
  ];

  meta = with lib; {
    description = "Dissect module implementing a parser for Event Trace Log (ETL) files";
    homepage = "https://github.com/fox-it/dissect.etl";
    changelog = "https://github.com/fox-it/dissect.etl/releases/tag/${version}";
    license = licenses.agpl3Only;
    maintainers = with maintainers; [ fab ];
  };
}
