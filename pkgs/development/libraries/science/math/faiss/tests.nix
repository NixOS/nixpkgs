{ lib
, buildPythonPackage
, faiss
, scipy
, pytestCheckHook
}:

assert faiss.pythonSupport;

buildPythonPackage {
  pname = "faiss-pytest-suite";
  inherit (faiss) version;

  src = "${faiss.src}/tests";

  dontBuild = true;
  dontInstall = true;

  # Tests that need GPUs and would fail in the sandbox
  disabledTestPaths = lib.optionals faiss.cudaSupport [
    "test_contrib.py"
  ];

  checkInputs = [
    faiss
    pytestCheckHook
    scipy
  ] ++
  faiss.extra-requires.all;
}
