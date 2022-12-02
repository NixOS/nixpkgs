{ lib
, buildPythonPackage
, cloudpickle
, dask
, distributed
, fetchPypi
, multipledispatch
, pytestCheckHook
, pythonOlder
, scikit-learn
, scipy
, setuptools-scm
, sparse
}:

buildPythonPackage rec {
  pname = "dask-glm";
  version = "0.2.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-WLhs6/BP5bnlgJLhxGfjLmDQHhG3H9xii6qp/G0a3uU=";
  };

  nativeBuildInputs = [
    setuptools-scm
  ];

  propagatedBuildInputs = [
    cloudpickle
    distributed
    multipledispatch
    scikit-learn
    scipy
    sparse
  ] ++ dask.optional-dependencies.array;

  checkInputs = [
    sparse
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "dask_glm"
  ];

  disabledTestPaths = [
    # Circular dependency with dask-ml
    "dask_glm/tests/test_estimators.py"
    # Test tries to imort an obsolete method
    "dask_glm/tests/test_utils.py"
  ];

  disabledTests = [
    # missing fixture with distributed>=2022.8.0
    "test_determinism_distributed"
  ];

  meta = with lib; {
    description = "Generalized Linear Models with Dask";
    homepage = "https://github.com/dask/dask-glm/";
    license = licenses.bsd3;
    maintainers = with maintainers; [ costrouc ];
  };
}
