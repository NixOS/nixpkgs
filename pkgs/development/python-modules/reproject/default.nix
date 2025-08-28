{
  lib,
  astropy,
  astropy-extension-helpers,
  astropy-healpix,
  buildPythonPackage,
  cloudpickle,
  cython,
  dask,
  extension-helpers,
  fetchPypi,
  fsspec,
  numpy,
  pytest-astropy,
  pytestCheckHook,
  pythonOlder,
  scipy,
  setuptools-scm,
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

  nativeBuildInputs = [
    astropy-extension-helpers
    cython
    numpy
    setuptools-scm
  ];

  propagatedBuildInputs = [
    astropy
    astropy-healpix
    cloudpickle
    dask
    extension-helpers
    fsspec
    numpy
    scipy
    zarr
  ]
  ++ dask.optional-dependencies.array;

  nativeCheckInputs = [
    pytest-astropy
    pytestCheckHook
  ];

  pytestFlags = [
    # Avoid failure due to user warning: Distutils was imported before Setuptools
    "-pno:warnings"
    # prevent "'filterwarnings' not found in `markers` configuration option" error
    "-omarkers=filterwarnings"
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
