{
  lib,
  buildPythonPackage,
  faiss,
  scipy,
  pytestCheckHook,
}:

assert faiss.pythonSupport;

buildPythonPackage {
  pname = "faiss-pytest-suite";
  inherit (faiss) version;

  format = "other";

  src = "${faiss.src}/tests";

  dontBuild = true;
  dontInstall = true;

  # Tests that need GPUs and would fail in the sandbox
  disabledTestPaths = lib.optionals faiss.cudaSupport [
    "test_contrib.py"
  ];

  disabledTests = [
    # https://github.com/facebookresearch/faiss/issues/2836
    "test_update_codebooks_with_double"
  ];

  nativeCheckInputs = [
    faiss
    pytestCheckHook
    scipy
  ] ++ faiss.extra-requires.all;
}
