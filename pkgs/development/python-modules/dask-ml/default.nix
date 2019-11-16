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
  version = "1.0.0";
  pname = "dask-ml";

  src = fetchPypi {
    inherit pname version;
    sha256 = "dde926478653bd03a3fbc501d3873a1534836608217b94d04320d1e1c07e59dc";
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
