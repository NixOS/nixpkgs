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
  version = "2021.11.30";
  pname = "dask-ml";
  disabled = pythonOlder "3.6"; # >= 3.6

  src = fetchPypi {
    inherit pname version;
    sha256 = "4f73306b5ee56e9b41b133697062d0028d30b1ece883ac6b56532fea5bd3e94a";
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
