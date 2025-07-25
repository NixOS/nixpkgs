{
  array-api-compat,
  awkward,
  boltons,
  buildPythonPackage,
  dask,
  distributed,
  fetchFromGitHub,
  filelock,
  h5py,
  hatch-vcs,
  hatchling,
  joblib,
  lib,
  natsort,
  numba,
  numpy,
  openpyxl,
  packaging,
  pandas,
  pyarrow,
  pytest-mock,
  pytest-xdist,
  pytestCheckHook,
  pythonOlder,
  scikit-learn,
  scipy,
  stdenv,
  typing-extensions,
  zarr,
}:

buildPythonPackage rec {
  pname = "anndata";
  version = "0.11.4";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "scverse";
    repo = "anndata";
    tag = version;
    hash = "sha256-9RDR0veZ8n2sq0kUbAkS2nP57u47cQxmubzuWWYBKBY=";
  };

  build-system = [
    hatch-vcs
    hatchling
  ];

  dependencies = [
    array-api-compat
    h5py
    natsort
    numpy
    pandas
    scipy
  ];

  nativeCheckInputs = [
    awkward
    boltons
    dask
    distributed
    filelock
    joblib
    numba
    openpyxl
    pyarrow
    pytest-mock
    pytest-xdist
    pytestCheckHook
    scikit-learn
    zarr
  ];

  # Optionally disable pytest-xdist to make it easier to debug the test suite.
  # Test suite takes ~5 minutes without pytest-xdist. Note that some tests will
  # fail when running without pytest-xdist ("worker_id not found").
  # pytestFlagsArray = [ "-o" "addopts=" ];

  disabledTestPaths = [
    # Tests that require scanpy, creating a circular dependency chain
    "src/anndata/_core/anndata.py"
    "src/anndata/_core/merge.py"
    "src/anndata/_core/sparse_dataset.py"
    "src/anndata/_io/specs/registry.py"
    "src/anndata/_io/utils.py"
    "src/anndata/_warnings.py"
    "src/anndata/experimental/merge.py"
    "src/anndata/experimental/multi_files/_anncollection.py"
    "src/anndata/utils.py"
  ];

  disabledTests = [
    # doctests that require scanpy, creating a circular dependency chain. These
    # do not work in disabledTestPaths for some reason.
    "anndata._core.anndata.AnnData.concatenate"
    "anndata._core.anndata.AnnData.obs_names_make_unique"
    "anndata._core.anndata.AnnData.var_names_make_unique"
    "anndata._core.merge.concat"
    "anndata._core.merge.gen_reindexer"
    "anndata._core.sparse_dataset.sparse_dataset"
    "anndata._io.specs.registry.read_elem_as_dask"
    "anndata._io.utils.report_read_key_on_error"
    "anndata._io.utils.report_write_key_on_error"
    "anndata._warnings.ImplicitModificationWarning"
    "anndata.experimental.merge.concat_on_disk"
    "anndata.experimental.multi_files._anncollection.AnnCollection"
    "anndata.utils.make_index_unique"
    "ci.scripts.min-deps.min_dep"
    "concatenation.rst"

    # Tests that require cupy and GPU access. Introducing cupy as a dependency
    # would make this package unfree and GPU access is not possible within the
    # nix build environment anyhow.
    "test_adata_raw_gpu"
    "test_as_cupy_dask"
    "test_as_dask_functions"
    "test_concat_different_types_dask"
    "test_concat_on_var_outer_join"
    "test_concatenate_layers_misaligned"
    "test_concatenate_layers_outer"
    "test_concatenate_layers"
    "test_concatenate_roundtrip"
    "test_dask_to_memory_unbacked"
    "test_ellipsis_index"
    "test_error_on_mixed_device"
    "test_gpu"
    "test_io_spec_cupy"
    "test_modify_view_component"
    "test_nan_merge"
    "test_pairwise_concat"
    "test_raw_gpu"
    "test_set_scalar_subset_X"
    "test_transposed_concat"
    "test_view_different_type_indices"
    "test_view_of_view"

    # Tests that are seemingly broken. See https://github.com/scverse/anndata/issues/2017.
    "test_concat_dask_sparse_matches_memory"
  ]
  ++ lib.optionals (stdenv.isAarch64 && stdenv.isDarwin) [
    # RuntimeError: Cluster failed to start: [Errno 1] Operation not permitted
    "test_dask_distributed_write"
    "test_read_lazy_h5_cluster"
  ];

  pythonImportsCheck = [ "anndata" ];

  meta = {
    changelog = "https://github.com/scverse/anndata/blob/main/docs/release-notes/${version}.md";
    description = "Python package for handling annotated data matrices in memory and on disk";
    homepage = "https://anndata.readthedocs.io/";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ samuela ];
  };
}
