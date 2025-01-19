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
  fsspec-xrootd,
  hist,
  lz4,
  matplotlib,
  mplhep,
  numba,
  numpy,
  packaging,
  pandas,
  pyarrow,
  requests,
  scipy,
  toml,
  tqdm,
  uproot,
  vector,

  # checks
  distributed,
  pyinstrument,
  pytestCheckHook,
  pytest-xdist,
}:

buildPythonPackage rec {
  pname = "coffea";
  version = "2025.1.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "CoffeaTeam";
    repo = "coffea";
    tag = "v${version}";
    hash = "sha256-l/HjTX3zm1jquAhuvNNI+oaC7TbaICNnmfqXxBNlaic=";
  };

  build-system = [
    hatchling
    hatch-vcs
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
    fsspec-xrootd
    hist
    lz4
    matplotlib
    mplhep
    numba
    numpy
    packaging
    pandas
    pyarrow
    requests
    scipy
    toml
    tqdm
    uproot
    vector
  ] ++ dask.optional-dependencies.array;

  nativeCheckInputs = [
    distributed
    pyinstrument
    pytestCheckHook
    pytest-xdist
  ];

  pythonImportsCheck = [ "coffea" ];

  disabledTests = [
    # Requires internet access
    # https://github.com/CoffeaTeam/coffea/issues/1094
    "test_lumimask"

    # Flaky: FileNotFoundError: [Errno 2] No such file or directory: 'nminusone.npz'
    # https://github.com/scikit-hep/coffea/issues/1246
    "test_packed_selection_nminusone_dak"
  ];

  __darwinAllowLocalNetworking = true;

  meta = {
    description = "Basic tools and wrappers for enabling not-too-alien syntax when running columnar Collider HEP analysis";
    homepage = "https://github.com/CoffeaTeam/coffea";
    changelog = "https://github.com/CoffeaTeam/coffea/releases/tag/v${version}";
    license = with lib.licenses; [ bsd3 ];
    maintainers = with lib.maintainers; [ veprbl ];
  };
}
