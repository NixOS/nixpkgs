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
  version = "0.10.0";
  pname = "dask-ml";

  src = fetchPypi {
    inherit pname version;
    sha256 = "4b6ca548c7282c1b6983e696e4bdfa0a2d7b51b168928b9322ea7a4b9a9f20f9";
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
