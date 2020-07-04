{ stdenv
, buildPythonPackage
, fetchPypi
, xgboost
, dask
, distributed
, pytest
, scikitlearn
}:

buildPythonPackage rec {
  version = "0.1.10";
  pname = "dask-xgboost";

  src = fetchPypi {
    inherit pname version;
    sha256 = "454c47ccf64315d35beeca32c7cedf20d8a8d42471d5e6ce0c51f4af0a6e021e";
  };

  checkInputs = [ pytest scikitlearn ];
  propagatedBuildInputs = [ xgboost dask distributed ];

  checkPhase = ''
    py.test dask_xgboost/tests/test_core.py
  '';

  doCheck = false;

  meta = with stdenv.lib; {
    homepage = "https://github.com/dask/dask-xgboost";
    description = "Interactions between Dask and XGBoost";
    license = licenses.bsd3;
    maintainers = [ maintainers.costrouc ];
  };
}
