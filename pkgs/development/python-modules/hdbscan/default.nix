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
  version = "0.8.12";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0yxi34frg2jwyvjl942qy4gq5pbx8dq4pf4p28d1xah8njchfqir";
  };

  checkInputs = [ nose ];

  propagatedBuildInputs = [ cython numpy scipy scikitlearn ];

  meta = with lib; {
    description = "Hierarchical Density-Based Spatial Clustering of Applications with Noise, a clustering algorithm with a scikit-learn compatible API";
    homepage =  http://github.com/scikit-learn-contrib/hdbscan;
    license = licenses.bsd3;
    maintainers = with maintainers; [ ixxie ];
  };
}
