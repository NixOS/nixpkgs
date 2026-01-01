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
<<<<<<< HEAD
  version = "0.1.3";
=======
  version = "0.1.3b1";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  pyproject = true;

  src = fetchFromGitHub {
    owner = "y-crdt";
    repo = "pycrdt-store";
    tag = version;
<<<<<<< HEAD
    hash = "sha256-KlB3BDhL/dt1IaQvWOfq1hgTKptrobgoBpus/mjZ26M=";
=======
    hash = "sha256-UMLR30PqtPUlD6z7VTPl7ZkSSw4HkmO5bUa/lSeFFoE=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
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

<<<<<<< HEAD
  disabledTestMarks = [ "flaky" ];

=======
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  pythonImportsCheck = [ "pycrdt.store" ];

  meta = {
    description = "Persistent storage for pycrdt";
    homepage = "https://github.com/y-crdt/pycrdt-store";
    changelog = "https://github.com/y-crdt/pycrdt-store/blob/${src.tag}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ sarahec ];
  };
}
