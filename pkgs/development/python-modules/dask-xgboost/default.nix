{ stdenv
, buildPythonPackage
, fetchPypi
, xgboost
, dask
, distributed
, pytest
, scikitlearn
, scipy
}:

buildPythonPackage rec {
  version = "0.1.5";
  pname = "dask-xgboost";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1860d06965fe68def1c83b9195130a92050fd4bc28bf2be689898a3a74ee1316";
  };

  checkInputs = [ pytest scikitlearn ];
  propagatedBuildInputs = [ xgboost dask distributed ];

  checkPhase = ''
    py.test dask_xgboost/tests/test_core.py
  '';

  doCheck = false;

  meta = with stdenv.lib; {
    homepage = https://github.com/dask/dask-xgboost;
    description = "Interactions between Dask and XGBoost";
    license = licenses.bsd3;
    maintainers = [ maintainers.costrouc ];
  };
}
