{ lib
, astropy
, astropy-extension-helpers
, astropy-healpix
, buildPythonPackage
, cloudpickle
, cython_3
, dask
, fetchPypi
, fsspec
, numpy
, oldest-supported-numpy
, pytest-astropy
, pytestCheckHook
, pythonOlder
, scipy
, setuptools-scm
, zarr
}:

buildPythonPackage rec {
  pname = "reproject";
  version = "0.13.0";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-lL6MkKVSWmV6KPkG/9fjc2c2dFQ14i9fiJAr3VFfcuI=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace "cython==" "cython>="
  '';

  nativeBuildInputs = [
    astropy-extension-helpers
    cython_3
    numpy
    oldest-supported-numpy
    setuptools-scm
  ];

  propagatedBuildInputs = [
    astropy
    astropy-healpix
    cloudpickle
    dask
    fsspec
    numpy
    scipy
    zarr
  ] ++ dask.optional-dependencies.array;

  nativeCheckInputs = [
    pytest-astropy
    pytestCheckHook
  ];

  pytestFlagsArray = [
    "build/lib*"
    # Avoid failure due to user warning: Distutils was imported before Setuptools
    "-p no:warnings"
    # Uses network
    "--ignore build/lib*/reproject/interpolation/"
  ];

  pythonImportsCheck = [
    "reproject"
  ];

  meta = with lib; {
    description = "Reproject astronomical images";
    downloadPage = "https://github.com/astropy/reproject";
    homepage = "https://reproject.readthedocs.io";
    changelog = "https://github.com/astropy/reproject/releases/tag/v${version}";
    license = licenses.bsd3;
    maintainers = with maintainers; [ smaret ];
  };
}
