{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  hatchling,
  hatch-vcs,

  # dependencies
  aiohttp,
  awkward,
  cachetools,
  cloudpickle,
  correctionlib,
  dask,
  dask-awkward,
  dask-histogram,
  fsspec,
  hist,
  ipywidgets,
  lz4,
  matplotlib,
  mplhep,
  numba,
  numpy,
  packaging,
  pandas,
  pyarrow,
  requests,
  rich,
  scipy,
  toml,
  tqdm,
  uproot,
  vector,

  # tests
  distributed,
  pyinstrument,
  pytest-xdist,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "coffea";
  version = "2025.11.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "CoffeaTeam";
    repo = "coffea";
    tag = "v${version}";
    hash = "sha256-vv1eHb8vt4nxdnpLmE0J5g/3oYmcoIykKCuOcQoxA60=";
  };

  build-system = [
    hatchling
    hatch-vcs
  ];

  pythonRelaxDeps = [
    "dask"
  ];

  dependencies = [
    aiohttp
    awkward
    cachetools
    cloudpickle
    correctionlib
    dask
    dask-awkward
    dask-histogram
    fsspec
    hist
    ipywidgets
    lz4
    matplotlib
    mplhep
    numba
    numpy
    packaging
    pandas
    pyarrow
    requests
    rich
    scipy
    toml
    tqdm
    uproot
    vector
  ]
  ++ dask.optional-dependencies.array;

  nativeCheckInputs = [
    distributed
    pyinstrument
    pytest-xdist
    pytestCheckHook
  ];

  pythonImportsCheck = [ "coffea" ];

  disabledTests = [
    # Requires internet access
    # https://github.com/CoffeaTeam/coffea/issues/1094
    "test_lumimask"

    # Flaky: FileNotFoundError: [Errno 2] No such file or directory
    # https://github.com/scikit-hep/coffea/issues/1246
    "test_packed_selection_cutflow_dak" # cutflow.npz
    "test_packed_selection_nminusone_dak" # nminusone.npz
  ];

  __darwinAllowLocalNetworking = true;

  meta = {
    description = "Basic tools and wrappers for enabling not-too-alien syntax when running columnar Collider HEP analysis";
    homepage = "https://github.com/CoffeaTeam/coffea";
    changelog = "https://github.com/CoffeaTeam/coffea/releases/tag/${src.tag}";
    license = with lib.licenses; [ bsd3 ];
    maintainers = with lib.maintainers; [ veprbl ];
  };
}
