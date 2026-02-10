{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  hatch-vcs,
  hatchling,

  # dependencies
  anndata,
  fast-array-utils,
  h5py,
  joblib,
  legacy-api-wrap,
  matplotlib,
  natsort,
  networkx,
  numba,
  numpy,
  packaging,
  pandas,
  patsy,
  pynndescent,
  scikit-learn,
  scipy,
  seaborn,
  session-info2,
  statsmodels,
  tqdm,
  typing-extensions,
  umap-learn,

  # optional-attrs
  # dask
  dask,
  # dask-ml
  dask-ml,
  # leiden
  igraph,
  leidenalg,
  # scrublet
  scikit-image,
  # skmisc
  scikit-misc,

  # tests
  jinja2,
  pytest-cov-stub,
  pytest-mock,
  pytest-randomly,
  pytest-rerunfailures,
  pytest-xdist,
  pytestCheckHook,
  tuna,
  writableTmpDirAsHomeHook,
  zarr,
}:

buildPythonPackage (finalAttrs: {
  pname = "scanpy";
  version = "1.12.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "scverse";
    repo = "scanpy";
    tag = finalAttrs.version;
    hash = "sha256-jpi3SyTaG5mxCqUNSM564MMIrNdz4LBYo9+dn5nYmeY=";
  };

  # Otherwise, several tests fail to be collected:
  # AssertionError: scanpy is already imported, this will mess up test coverage
  postPatch = ''
    substituteInPlace src/testing/scanpy/_pytest/__init__.py \
      --replace-fail \
        'assert "scanpy" not in sys.modules,' \
        'assert True,'
  '';

  build-system = [
    hatch-vcs
    hatchling
  ];

  dependencies = [
    anndata
    fast-array-utils
    h5py
    joblib
    legacy-api-wrap
    matplotlib
    natsort
    networkx
    numba
    numpy
    packaging
    pandas
    patsy
    pynndescent
    scikit-learn
    scipy
    seaborn
    session-info2
    statsmodels
    tqdm
    typing-extensions
    umap-learn
  ]
  ++ fast-array-utils.optional-dependencies.accel
  ++ fast-array-utils.optional-dependencies.sparse;

  optional-dependencies = {
    # commented attributes are due to some dependencies not being in Nixpkgs
    #bbknn = [
    #  bbknn
    #];
    dask = [
      anndata
      dask
    ];
    dask-ml = [
      dask-ml
    ];
    #harmony = [
    #  harmonypy
    #];
    leiden = [
      igraph
      leidenalg
    ];
    #louvain = [
    #  igraph
    #  louvain
    #];
    #magic = [
    #  magic-impute
    #];
    paga = [
      igraph
    ];
    #rapids = [
    #  cudf
    #  cugraph
    #  cuml
    #];
    #scanorama = [
    #  scanorama
    #];
    scrublet = [
      scikit-image
    ];
    skmisc = [
      scikit-misc
    ];
  };

  nativeCheckInputs = [
    jinja2
    pytest-cov-stub
    pytest-mock
    pytest-randomly
    pytest-rerunfailures
    pytest-xdist
    pytestCheckHook
    tuna
    writableTmpDirAsHomeHook
    zarr
  ];

  preCheck = ''
    export NUMBA_CACHE_DIR=$(mktemp -d);
  '';

  disabledTestPaths = [
    # try to download data:
    "tests/test_aggregated.py"
    "tests/test_highly_variable_genes.py"
    "tests/test_normalization.py"
    "tests/test_pca.py"
    "tests/test_plotting.py"
    "tests/test_plotting_embedded/"

    # fixture 'backed_adata' not found
    "tests/test_backed.py"
  ];

  disabledTests = [
    # try to download data:
    "scanpy.get._aggregated.aggregate"
    "scanpy.plotting._tools.scatterplots.spatial"
    "test_burczynski06"
    "test_clip"
    "test_doc_shape"
    "test_download_failure"
    "test_ebi_expression_atlas"
    "test_mean_var"
    "test_paul15"
    "test_pbmc3k"
    "test_pbmc3k_processed"
    "test_regress_out_int"
    "test_score_with_reference"
    "test_visium_datasets"
    "test_visium_datasets_dir_change"
    "test_visium_datasets_images"

    # fails to find the trivial test script for some reason:
    "test_external"

    # fixture 'original_settings' not found
    "test_defaults"

    # AssertionError: Not equal to tolerance rtol=1e-07, atol=0
    "test_connectivities_euclidean"

    # assert sc.settings.autoshow
    # AssertionError: assert False
    "test_resets"

    # FileNotFoundError: [Errno 2] Unable to synchronously create file (unable to open file: name =
    # 'write/test.h5ad', errno = 2, error message = 'No such file or directory', flags = 13, o_flags
    # = 242)
    "test_write"
  ];

  pythonImportsCheck = [ "scanpy" ];

  meta = {
    description = "Single-cell analysis in Python which scales to >100M cells";
    homepage = "https://scanpy.readthedocs.io";
    changelog = "https://github.com/scverse/scanpy/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ bcdarwin ];
    mainProgram = "scanpy";
  };
})
