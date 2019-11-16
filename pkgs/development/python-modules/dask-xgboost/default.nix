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
  version = "0.1.9";
  pname = "dask-xgboost";

  src = fetchPypi {
    inherit pname version;
    sha256 = "6faeeed044112151e28770b69fb1ad06b026597726ce8dc185fd3ae45363d0c0";
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
