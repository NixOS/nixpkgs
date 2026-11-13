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

  pyproject = false;

  src = "${faiss-build.src}/tests";

  dontBuild = true;
  dontInstall = true;

  disabledTestPaths = [
    # ModuleNotFoundError: No module named 'faiss.faiss_example_external_module'
    "external_module_test.py"

    # Loads benchs/e_means/dino_data.py, which is outside of src
    "test_dino_data.py"
  ]
  # Tests that need GPUs and would fail in the sandbox
  ++ lib.optionals faiss.cudaSupport [ "test_contrib.py" ];

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
