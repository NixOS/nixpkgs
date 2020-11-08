{ stdenv
, buildPythonPackage
, fetchPypi
, pythonOlder
, dask
, numpy, toolz # dask[array]
, numba
, pandas
, scikitlearn
, scipy
, dask-glm
, six
, multipledispatch
, packaging
, pytest
, xgboost
, tensorflow
, joblib
, distributed
}:

buildPythonPackage rec {
  version = "1.6.0";
  pname = "dask-ml";
  disabled = pythonOlder "3.6"; # >= 3.6

  src = fetchPypi {
    inherit pname version;
    sha256 = "ce686b7fd49b3f876d651c87e8468ad71bcd2707399140d6baf198184c45d970";
  };

  requiredPythonModules = [
    dask
    dask-glm
    distributed
    multipledispatch
    numba
    numpy
    packaging
    pandas
    scikitlearn
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

  meta = with stdenv.lib; {
    homepage = "https://github.com/dask/dask-ml";
    description = "Scalable Machine Learn with Dask";
    license = licenses.bsd3;
    maintainers = [ maintainers.costrouc ];
  };
}
