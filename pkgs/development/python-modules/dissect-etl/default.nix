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
  version = "3.11";
  pyproject = true;

  disabled = pythonOlder "3.10";

  src = fetchFromGitHub {
    owner = "fox-it";
    repo = "dissect.etl";
    tag = version;
    hash = "sha256-soJH7kx/029yXyOjv6OsWjWAMMHXKx711GLPBClDAK0=";
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

  disabledTests = [
    # Invalid header magic
    "test_sqlite"
    "test_empty"
  ];

  meta = with lib; {
    description = "Dissect module implementing a parser for Event Trace Log (ETL) files";
    homepage = "https://github.com/fox-it/dissect.etl";
    changelog = "https://github.com/fox-it/dissect.etl/releases/tag/${src.tag}";
    license = licenses.agpl3Only;
    maintainers = with maintainers; [ fab ];
  };
}
