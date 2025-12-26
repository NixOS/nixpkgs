{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  setuptools,

  # dependencies
  embedding-reader,
  faiss,
  fire,
  fsspec,
  numpy,
  pyarrow,

  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "autofaiss";
  version = "2.18.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "criteo";
    repo = "autofaiss";
    tag = version;
    hash = "sha256-XuubpTxmyKdV9nWqLTljp5cNyIwLt2BKJYcBzwPNzD8=";
  };

  build-system = [
    setuptools
  ];

  pythonRemoveDeps = [
    # The `dataclasses` packages is a python2-only backport, unnecessary in
    # python3.
    "dataclasses"
    # We call it faiss, not faiss-cpu.
    "faiss-cpu"
  ];

  pythonRelaxDeps = [
    # As of v2.15.4, autofaiss asks for fire<0.5 but we have fire v0.5.0 in
    # nixpkgs at the time of writing (2022-12-25).
    "fire"
    # As of v2.15.3, autofaiss asks for pyarrow<8 but we have pyarrow v9.0.0 in
    # nixpkgs at the time of writing (2022-12-15).
    "pyarrow"

    # No official numpy2 support yet
    "numpy"
  ];

  dependencies = [
    embedding-reader
    faiss
    fire
    fsspec
    numpy
    pyarrow
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  disabledTests = [
    # Attempts to spin up a Spark cluster and talk to it which doesn't work in
    # the Nix build environment.
    "test_build_partitioned_indexes"
    "test_index_correctness_in_distributed_mode_with_multiple_indices"
    "test_index_correctness_in_distributed_mode"
    "test_quantize_with_pyspark"

    # TypeError: Object of type float32 is not JSON serializable
    "test_quantize"
    "test_quantize_with_empty_and_non_empty_files"
    "test_quantize_with_ids"
    "test_quantize_with_multiple_inputs"
  ];

  meta = {
    description = "Automatically create Faiss knn indices with the most optimal similarity search parameters";
    mainProgram = "autofaiss";
    homepage = "https://github.com/criteo/autofaiss";
    changelog = "https://github.com/criteo/autofaiss/blob/${version}/CHANGELOG.md";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ samuela ];
  };
}
