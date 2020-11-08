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
  version = "0.1.11";
  pname = "dask-xgboost";

  src = fetchPypi {
    inherit pname version;
    sha256 = "3fbe1bf4344dc74edfbe9f928c7e3e6acc26dc57cefd8da8ae56a15469c6941c";
  };

  checkInputs = [ pytest scikitlearn ];
  requiredPythonModules = [ xgboost dask distributed ];

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
