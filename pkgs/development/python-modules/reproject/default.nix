{
  lib,
  asdf,
  astropy,
  astropy-healpix,
  buildPythonPackage,
  cython,
  dask,
  extension-helpers,
  fetchFromGitHub,
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

  src = fetchFromGitHub {
    owner = "astropy";
    repo = "reproject";
    tag = "v${version}";
    hash = "sha256-gv5LOxXTNdHSx4Q4ydi/QBHhc7/E/DXJD7WuPBAH0dE=";
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
