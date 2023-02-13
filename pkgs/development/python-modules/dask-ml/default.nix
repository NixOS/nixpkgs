{ lib
, buildPythonPackage
, dask
, dask-glm
, distributed
, fetchPypi
, multipledispatch
, numba
, numpy
, packaging
, pandas
, pythonOlder
, scikit-learn
, scipy
, setuptools-scm
}:

buildPythonPackage rec {
  pname = "dask-ml";
  version = "2022.5.27";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-Y2nTk0GSvMGSP87oTD+4+8zsoQITeQEHC6Px2eOGzOQ=";
  };

  nativeBuildInputs = [
    setuptools-scm
  ];

  propagatedBuildInputs = [
    dask-glm
    distributed
    multipledispatch
    numba
    numpy
    packaging
    pandas
    scikit-learn
    scipy
  ] ++ dask.optional-dependencies.array
    ++ dask.optional-dependencies.dataframe;

  # has non-standard build from source, and pypi doesn't include tests
  doCheck = false;

  pythonImportsCheck = [
    "dask_ml"
    "dask_ml.naive_bayes"
    "dask_ml.wrappers"
    "dask_ml.utils"
  ];

  meta = with lib; {
    description = "Scalable Machine Learn with Dask";
    homepage = "https://github.com/dask/dask-ml";
    license = licenses.bsd3;
    maintainers = with maintainers; [ costrouc ];
  };
}
