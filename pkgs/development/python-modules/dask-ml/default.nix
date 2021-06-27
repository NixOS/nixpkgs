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
  version = "1.9.0";
  pname = "dask-ml";
  disabled = pythonOlder "3.6"; # >= 3.6

  src = fetchPypi {
    inherit pname version;
    sha256 = "2f376a7114133b484a6d393f62298473116fc49c79ec7d50d5b031d752f54307";
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
