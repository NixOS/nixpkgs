{ lib
, buildPythonPackage
, fetchPypi
, xgboost
, dask
, distributed
}:

buildPythonPackage rec {
  version = "0.2.0";
  pname = "dask-xgboost";

  src = fetchPypi {
    inherit pname version;
    sha256 = "6d9c491dc4099f74a0df66c4d439d296c0f1fba97009fe93e21b2350f295b4ca";
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
