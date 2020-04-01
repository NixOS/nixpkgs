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
  version = "0.8.25";

  src = fetchPypi {
    inherit pname version;
    sha256 = "17mi4nlifaygfw3n5ark5mfzx71pjxz3h6l455sh0i5mzh6czk4j";
  };

  checkInputs = [ nose ];

  nativeBuildInputs = [ cython ];
  propagatedBuildInputs = [ numpy scipy scikitlearn joblib six ];

  meta = with lib; {
    description = "Hierarchical Density-Based Spatial Clustering of Applications with Noise, a clustering algorithm with a scikit-learn compatible API";
    homepage =  https://github.com/scikit-learn-contrib/hdbscan;
    license = licenses.bsd3;
    maintainers = with maintainers; [ ixxie ];
  };
}
