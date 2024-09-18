{
  lib,
  buildPythonPackage,
  faiss,
  faiss-build,
  scipy,
  pytestCheckHook,
}:

assert faiss.pythonSupport;

buildPythonPackage {
  pname = "faiss-pytest-suite";
  inherit (faiss) version;

  format = "other";

  src = "${faiss-build.src}/tests";

  dontBuild = true;
  dontInstall = true;

  # Tests that need GPUs and would fail in the sandbox
  disabledTestPaths = lib.optionals faiss.cudaSupport [ "test_contrib.py" ];

  disabledTests = [
    # https://github.com/facebookresearch/faiss/issues/2836
    "test_update_codebooks_with_double"
  ];

  nativeCheckInputs = [
    faiss
    pytestCheckHook
    scipy
  ];

  meta = faiss.meta // {
    description = "Faiss test suite";
  };
}
