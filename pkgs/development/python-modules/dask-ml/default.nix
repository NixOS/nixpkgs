{ stdenv
, buildPythonPackage
, fetchPypi
, dask
, numpy, toolz # dask[array]
, numba
, pandas
, scikitlearn
, scipy
, dask-glm
, six
, multipledispatch
, packaging
, pytest
, xgboost
, tensorflow
, joblib
, distributed
}:

buildPythonPackage rec {
  version = "0.11.0";
  pname = "dask-ml";

  src = fetchPypi {
    inherit pname version;
    sha256 = "a9e8e69494560dc23534adb236e88b3b21dc30a156648453c9c6e4b27ff2df96";
  };

  checkInputs = [ pytest xgboost tensorflow joblib distributed ];
  propagatedBuildInputs = [ dask numpy toolz numba pandas scikitlearn scipy dask-glm six multipledispatch packaging ];

  # dask-ml has some heavy test requirements
  # and requires some very new packages
  doCheck = false;

  meta = with stdenv.lib; {
    homepage = https://github.com/dask/dask-ml;
    description = "Scalable Machine Learn with Dask";
    license = licenses.bsd3;
    maintainers = [ maintainers.costrouc ];
  };
}
