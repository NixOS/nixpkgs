{
  anndata,
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
  legacy-api-wrap,
  natsort,
  numba,
  numpy,
  openpyxl,
  pandas,
  pyarrow,
  pytest-mock,
  pytest-xdist,
  pytestCheckHook,
  scanpy,
  scikit-learn,
  scipy,
  stdenv,
  zarr,
}:

buildPythonPackage rec {
  pname = "anndata";
  version = "0.12.6";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "scverse";
    repo = "anndata";
    tag = version;
    hash = "sha256-VFZrPcb6uaBSOPxJKTJtcYewD8K2Qrsuk3/7+QW6F78=";
  };

  build-system = [
    hatch-vcs
    hatchling
  ];

  dependencies = [
    array-api-compat
    h5py
    legacy-api-wrap
    natsort
    numpy
    pandas
    scipy
    zarr
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
    scanpy
  ];

  # Optionally disable pytest-xdist to make it easier to debug the test suite.
  # Test suite takes ~5 minutes without pytest-xdist. Note that some tests will
  # fail when running without pytest-xdist ("worker_id not found").
  # pytestFlags = [ "-oaddopts=" ];

  preCheck = ''
    export NUMBA_CACHE_DIR=$(mktemp -d);
  '';

  doCheck = false; # use passthru.tests instead to prevent circularity with `scanpy`

  passthru.tests = anndata.overridePythonAttrs { doCheck = true; };

  disabledTests = [
    # requires data from a previous test execution:
    "test_no_diff"

    # try to download data:
    "anndata._io.specs.registry.read_elem_lazy"
    "anndata.experimental.merge.concat_on_disk"
    "anndata.experimental.multi_files._anncollection.AnnCollection"

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
