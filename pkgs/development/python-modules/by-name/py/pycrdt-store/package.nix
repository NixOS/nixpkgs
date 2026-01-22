{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  hatchling,

  # dependencies
  anyio,
  pycrdt,
  sqlite-anyio,

  # tests
  pytestCheckHook,
  trio,
}:

buildPythonPackage rec {
  pname = "pycrdt-store";
  version = "0.1.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "y-crdt";
    repo = "pycrdt-store";
    tag = version;
    hash = "sha256-KlB3BDhL/dt1IaQvWOfq1hgTKptrobgoBpus/mjZ26M=";
  };

  build-system = [
    hatchling
  ];

  dependencies = [
    anyio
    pycrdt
    sqlite-anyio
  ];

  nativeCheckInputs = [
    pytestCheckHook
    trio
  ];

  disabledTestMarks = [ "flaky" ];

  pythonImportsCheck = [ "pycrdt.store" ];

  meta = {
    description = "Persistent storage for pycrdt";
    homepage = "https://github.com/y-crdt/pycrdt-store";
    changelog = "https://github.com/y-crdt/pycrdt-store/blob/${src.tag}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ sarahec ];
  };
}
