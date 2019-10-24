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
  version = "0.1.7";
  pname = "dask-xgboost";

  src = fetchPypi {
    inherit pname version;
    sha256 = "c4eb7989e0b4bcab956c5ab5f89c3419016615ad1ca8f6596ca471e402aae43b";
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
