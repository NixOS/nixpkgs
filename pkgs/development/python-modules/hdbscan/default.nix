{ lib
, buildPythonPackage
, cython
, numpy
, nose
, scipy
, scikitlearn
, fetchPypi
}:

buildPythonPackage rec {
  pname = "hdbscan";
  version = "0.8.15";

  src = fetchPypi {
    inherit pname version;
    sha256 = "446f98e1ea622a39c1f396d839fa2b1c35db98234e373336de61c3bd6ffaec78";
  };

  checkInputs = [ nose ];

  propagatedBuildInputs = [ cython numpy scipy scikitlearn ];

  meta = with lib; {
    description = "Hierarchical Density-Based Spatial Clustering of Applications with Noise, a clustering algorithm with a scikit-learn compatible API";
    homepage =  https://github.com/scikit-learn-contrib/hdbscan;
    license = licenses.bsd3;
    maintainers = with maintainers; [ ixxie ];
  };
}
