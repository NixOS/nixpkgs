{ lib
, awkward
, buildPythonPackage
, cachetools
, cloudpickle
, correctionlib
, dask
, dask-awkward
, dask-histogram
, distributed
, fetchFromGitHub
, fsspec-xrootd
, hatch-vcs
, hatchling
, hist
, lz4
, matplotlib
, mplhep
, numba
, numpy
, packaging
, pandas
, pyarrow
, pyinstrument
, pytestCheckHook
, pythonOlder
, scipy
, toml
, tqdm
, uproot
}:

buildPythonPackage rec {
  pname = "coffea";
  version = "2024.2.1";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "CoffeaTeam";
    repo = "coffea";
    rev = "refs/tags/v${version}";
    hash = "sha256-TQ0aC2iFPWh24ce1WoVRluPvnwvBscLtFl8/wcW/Clg=";
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

  meta = with lib; {
    description = "Basic tools and wrappers for enabling not-too-alien syntax when running columnar Collider HEP analysis";
    homepage = "https://github.com/CoffeaTeam/coffea";
    changelog = "https://github.com/CoffeaTeam/coffea/releases/tag/v${version}";
    license = with licenses; [ bsd3 ];
    maintainers = with maintainers; [ veprbl ];
  };
}
