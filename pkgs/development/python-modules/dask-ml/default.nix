{ lib
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
, distributed
, setuptools-scm
}:

buildPythonPackage rec {
  version = "1.8.0";
  pname = "dask-ml";
  disabled = pythonOlder "3.6"; # >= 3.6

  src = fetchPypi {
    inherit pname version;
    sha256 = "8fc4ac3ec1915e382fb8cae9ff1ec9b5ac1bee0b6f4c6975d6e6cb7191a4a815";
  };

  propagatedBuildInputs = [
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
    setuptools-scm
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
