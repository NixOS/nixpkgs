{ lib
, buildPythonPackage
, fetchFromGitHub
, hatchling
, hatch-vcs
, awkward
, uproot
, dask
, dask-awkward
, dask-histogram
, correctionlib
, pyarrow
, fsspec
, matplotlib
, numba
, numpy
, scipy
, tqdm
, lz4
, cloudpickle
, toml
, mplhep
, packaging
, pandas
, hist
, cachetools
, distributed
, pyinstrument
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "coffea";
  version = "2023.6.0.rc1";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "CoffeaTeam";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-TEtQ2KnwcylQbprlRtgHv7HIFg7roDWD4TihrQE4icU=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace "numba>=0.57.0" "numba" \
      --replace "numpy>=1.22.0,<1.25" "numpy"
  '';

  nativeBuildInputs = [
    hatchling
    hatch-vcs
  ];

  propagatedBuildInputs = [
    awkward
    uproot
    dask
    dask.optional-dependencies.array
    dask-awkward
    dask-histogram
    correctionlib
    pyarrow
    fsspec
    matplotlib
    numba
    numpy
    scipy
    tqdm
    lz4
    cloudpickle
    toml
    mplhep
    packaging
    pandas
    hist
    cachetools
  ];

  SETUPTOOLS_SCM_PRETEND_VERSION = version;

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
    license = with licenses; [ bsd3 ];
    maintainers = with maintainers; [ veprbl ];
  };
}
