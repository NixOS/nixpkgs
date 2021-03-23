{ lib
, buildPythonPackage
, cython
, numpy
, nose
, scipy
, scikitlearn
, fetchPypi
, joblib
, six
}:

buildPythonPackage rec {
  pname = "hdbscan";
  version = "0.8.27";

  src = fetchPypi {
    inherit pname version;
    sha256 = "e3a418d0d36874f7b6a1bf0b7461f3857fc13a525fd48ba34caed2fe8973aa26";
  };

  checkInputs = [ nose ];

  nativeBuildInputs = [ cython ];
  propagatedBuildInputs = [ numpy scipy scikitlearn joblib six ];

  meta = with lib; {
    description = "Hierarchical Density-Based Spatial Clustering of Applications with Noise, a clustering algorithm with a scikit-learn compatible API";
    homepage =  "https://github.com/scikit-learn-contrib/hdbscan";
    license = licenses.bsd3;
    maintainers = with maintainers; [ ixxie ];
  };
}
