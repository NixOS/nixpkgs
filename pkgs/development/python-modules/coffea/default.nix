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
  version = "2024.9.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "CoffeaTeam";
    repo = "coffea";
    rev = "refs/tags/v${version}";
    hash = "sha256-IX9c1EhQfFF2Gsn8atxngJ4gpgrwX5SnolUQ3nphhUY=";
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
