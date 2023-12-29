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
  version = "2023.12.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "CoffeaTeam";
    repo = "coffea";
    rev = "refs/tags/v${version}";
    hash = "sha256-Xlud3ibdI4UnoHe72NPc7WQojuWPpXtncENDinYgk4o=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace "numba>=0.58.1" "numba"
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
