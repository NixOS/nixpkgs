{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  hatch-vcs,
  hatchling,
  anndata,
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
  dask,
  dask-ml,

  igraph,
  leidenalg,
  scikit-image,
  scikit-misc,
  zarr,
  pytestCheckHook,
  pytest-cov-stub,
  pytest-mock,
  pytest-randomly,
  pytest-rerunfailures,
  pytest-xdist,
  tuna,
}:

buildPythonPackage rec {
  pname = "scanpy";
  version = "1.11.4";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "scverse";
    repo = "scanpy";
    tag = version;
    hash = "sha256-EvNelorfLOpYLGGZ1RSq4+jk6emuCWCKBdUop24iLf4=";
  };

  build-system = [
    hatch-vcs
    hatchling
  ];

  dependencies = [
    anndata
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
  ];

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
    pytestCheckHook
    pytest-cov-stub
    pytest-mock
    pytest-randomly
    pytest-rerunfailures
    pytest-xdist
    tuna
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
  ];

  disabledTests = [
    # try to download data:
    "scanpy.get._aggregated.aggregate"
    "scanpy.plotting._tools.scatterplots.spatial"
    "test_clip"
    "test_download_failure"
    "test_mean_var"
    "test_regress_out_int"
    "test_score_with_reference"

    # fails to find the trivial test script for some reason:
    "test_external"

    # AssertionError: Not equal to tolerance rtol=1e-07, atol=0
    "test_connectivities_euclidean"
  ];

  pythonImportsCheck = [
    "scanpy"
  ];

  meta = {
    description = "Single-cell analysis in Python which scales to >100M cells";
    homepage = "https://scanpy.readthedocs.io";
    changelog = "https://github.com/scverse/scanpy/releases/tag/${src.tag}";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ bcdarwin ];
    mainProgram = "scanpy";
  };
}
