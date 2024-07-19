{
  lib,
  buildPythonPackage,
  defusedxml,
  dissect-cstruct,
  dissect-util,
  fetchFromGitHub,
  setuptools,
  setuptools-scm,
  pytestCheckHook,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "dissect-etl";
  version = "3.10";
  pyproject = true;

  disabled = pythonOlder "3.10";

  src = fetchFromGitHub {
    owner = "fox-it";
    repo = "dissect.etl";
    rev = "refs/tags/${version}";
    hash = "sha256-c8qbh0LSTAV23J//Kx76eeIjptW1cVcxBSqO22okRkU=";
  };

  build-system = [
    setuptools
    setuptools-scm
  ];

  dependencies = [
    defusedxml
    dissect-cstruct
    dissect-util
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "dissect.etl" ];

  meta = with lib; {
    description = "Dissect module implementing a parser for Event Trace Log (ETL) files";
    homepage = "https://github.com/fox-it/dissect.etl";
    changelog = "https://github.com/fox-it/dissect.etl/releases/tag/${version}";
    license = licenses.agpl3Only;
    maintainers = with maintainers; [ fab ];
  };
}
