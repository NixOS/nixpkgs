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

buildPythonPackage (finalAttrs: {
  pname = "pycrdt-store";
  version = "0.1.4";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "y-crdt";
    repo = "pycrdt-store";
    tag = finalAttrs.version;
    hash = "sha256-njahh5wbUGYkXh/ibZYH+2gmvqegaD8LwlhNDpYFTcM=";
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
    changelog = "https://github.com/y-crdt/pycrdt-store/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ sarahec ];
  };
})
