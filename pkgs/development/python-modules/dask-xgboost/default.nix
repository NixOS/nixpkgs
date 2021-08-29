{ lib
, buildPythonPackage
, fetchPypi
, xgboost
, dask
, distributed
}:

buildPythonPackage rec {
  version = "0.1.11";
  pname = "dask-xgboost";

  src = fetchPypi {
    inherit pname version;
    sha256 = "3fbe1bf4344dc74edfbe9f928c7e3e6acc26dc57cefd8da8ae56a15469c6941c";
  };

  propagatedBuildInputs = [ xgboost dask distributed ];

  doCheck = false;
  pythonImportsCheck = [ "dask_xdgboost" ];

  meta = with lib; {
    homepage = "https://github.com/dask/dask-xgboost";
    description = "Interactions between Dask and XGBoost";
    license = licenses.bsd3;
    maintainers = [ maintainers.costrouc ];
    # TypeError: __init__() got an unexpected keyword argument 'iid'
    broken = true;
  };
}
