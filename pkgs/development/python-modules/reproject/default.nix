{
  lib,
  asdf,
  astropy,
  astropy-healpix,
  buildPythonPackage,
  cython,
  dask,
  extension-helpers,
  fetchPypi,
  fsspec,
  gwcs,
  numpy,
  pillow,
  pyavm,
  pytest-astropy,
  pytest-xdist,
  pytestCheckHook,
  pythonOlder,
  scipy,
  setuptools,
  setuptools-scm,
  shapely,
  tqdm,
  zarr,
}:

buildPythonPackage rec {
  pname = "reproject";
  version = "0.15.0";
  pyproject = true;

  disabled = pythonOlder "3.10";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-l9pmxtXIGnl8T8fCsUp/5y3kReg3MXdaN0i2rpcEqE4=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace "cython==" "cython>="
  '';

  build-system = [
    setuptools
    setuptools-scm
    cython
    extension-helpers
    numpy
  ];

  dependencies = [
    astropy
    astropy-healpix
    dask
    fsspec
    numpy
    pillow
    pyavm
    scipy
    zarr
  ]
  ++ dask.optional-dependencies.array;

  nativeCheckInputs = [
    pytestCheckHook
    pytest-astropy
    pytest-xdist
    asdf
    gwcs
    shapely
    tqdm
  ];

  enabledTestPaths = [
    "build/lib*"
  ];

  disabledTestPaths = [
    # Uses network
    "build/lib*/reproject/interpolation/"
  ];

  pythonImportsCheck = [ "reproject" ];

  meta = with lib; {
    description = "Reproject astronomical images";
    downloadPage = "https://github.com/astropy/reproject";
    homepage = "https://reproject.readthedocs.io";
    changelog = "https://github.com/astropy/reproject/releases/tag/v${version}";
    license = licenses.bsd3;
    maintainers = with maintainers; [ smaret ];
  };
}
