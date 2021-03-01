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
  version = "0.8.26";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0zlj2y42f0hrklviv21j9m895259ad8273dxgh7b44702781r9l1";
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
