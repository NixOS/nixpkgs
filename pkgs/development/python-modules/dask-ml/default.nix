{ lib
, buildPythonPackage
, fetchPypi
, pythonOlder
, dask
, numpy, toolz # dask[array]
, numba
, pandas
, scikit-learn
, scipy
, dask-glm
, six
, multipledispatch
, packaging
, distributed
, setuptools-scm
}:

buildPythonPackage rec {
  version = "2022.5.27";
  pname = "dask-ml";
  disabled = pythonOlder "3.6"; # >= 3.6

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-Y2nTk0GSvMGSP87oTD+4+8zsoQITeQEHC6Px2eOGzOQ=";
  };

  nativeBuildInputs = [
    setuptools-scm
  ];

  propagatedBuildInputs = [
    dask
    dask-glm
    distributed
    multipledispatch
    numba
    numpy
    packaging
    pandas
    scikit-learn
    scipy
    six
    toolz
  ];

  # has non-standard build from source, and pypi doesn't include tests
  doCheck = false;

  # in lieu of proper tests
  pythonImportsCheck = [
    "dask_ml"
    "dask_ml.naive_bayes"
    "dask_ml.wrappers"
    "dask_ml.utils"
  ];

  meta = with lib; {
    homepage = "https://github.com/dask/dask-ml";
    description = "Scalable Machine Learn with Dask";
    license = licenses.bsd3;
    maintainers = [ maintainers.costrouc ];
  };
}
