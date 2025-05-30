{
  lib,
  buildPythonPackage,
  dissect-cstruct,
  dissect-util,
  fetchFromGitHub,
  pytestCheckHook,
  pythonOlder,
  setuptools,
  setuptools-scm,
}:

buildPythonPackage rec {
  pname = "dissect-sql";
  version = "3.11";
  pyproject = true;

  disabled = pythonOlder "3.10";

  src = fetchFromGitHub {
    owner = "fox-it";
    repo = "dissect.sql";
    tag = version;
    hash = "sha256-1rIsG4TUv7JkNMiyGCbEEnnp2RccP8QksE91p3z1zjY=";
  };

  build-system = [
    setuptools
    setuptools-scm
  ];

  dependencies = [
    dissect-cstruct
    dissect-util
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "dissect.sql" ];

  disabledTests = [
    # Invalid header magic
    "test_sqlite"
    "test_empty"
  ];

  meta = with lib; {
    description = "Dissect module implementing a parsers for the SQLite database file format";
    homepage = "https://github.com/fox-it/dissect.sql";
    changelog = "https://github.com/fox-it/dissect.sql/releases/tag/${src.tag}";
    license = licenses.agpl3Only;
    maintainers = with maintainers; [ fab ];
  };
}
