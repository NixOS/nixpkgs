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
  version = "3.9";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "fox-it";
    repo = "dissect.sql";
    rev = "refs/tags/${version}";
    hash = "sha256-aq/p6oa+6C2BS2TV8YYXwGP580tIHYZqO455bYm0yeo=";
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

  meta = with lib; {
    description = "Dissect module implementing a parsers for the SQLite database file format";
    homepage = "https://github.com/fox-it/dissect.sql";
    changelog = "https://github.com/fox-it/dissect.sql/releases/tag/${version}";
    license = licenses.agpl3Only;
    maintainers = with maintainers; [ fab ];
  };
}
