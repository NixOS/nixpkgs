{ lib
, buildPythonPackage
, pythonOlder
, fetchFromGitHub
, hatchling
, hatch-vcs
, awkward
, cachetools
, cloudpickle
, correctionlib
, dask
, dask-awkward
, dask-histogram
, fsspec-xrootd
, hist
, lz4
, matplotlib
, mplhep
, numba
, numpy
, packaging
, pandas
, pyarrow
, scipy
, toml
, tqdm
, uproot
, distributed
, pyinstrument
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "coffea";
  version = "2024.4.1";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "CoffeaTeam";
    repo = "coffea";
    rev = "refs/tags/v${version}";
    hash = "sha256-Iu1GHnLUqdhYO7hoHaf+O/S6KO0P+dvl0wgfRA5vtGI=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail "numba>=0.58.1" "numba"
  '';

  nativeBuildInputs = [
    hatchling
    hatch-vcs
  ];

  propagatedBuildInputs = [
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
    scipy
    toml
    tqdm
    uproot
  ] ++ dask.optional-dependencies.array;

  nativeCheckInputs = [
    distributed
    pyinstrument
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "coffea"
  ];

  __darwinAllowLocalNetworking = true;

  meta = with lib; {
    description = "Basic tools and wrappers for enabling not-too-alien syntax when running columnar Collider HEP analysis";
    homepage = "https://github.com/CoffeaTeam/coffea";
    changelog = "https://github.com/CoffeaTeam/coffea/releases/tag/v${version}";
    license = with licenses; [ bsd3 ];
    maintainers = with maintainers; [ veprbl ];
  };
}
