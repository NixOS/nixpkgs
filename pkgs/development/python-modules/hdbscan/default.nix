{ lib
, buildPythonPackage
, cython
, numpy
, nose
, scipy
, scikitlearn
, fetchPypi
, joblib
}:

buildPythonPackage rec {
  pname = "hdbscan";
  version = "0.8.22";

  src = fetchPypi {
    inherit pname version;
    sha256 = "5cfdc25375123eb9a72363449979141cc928c1953f220f0f81d7baabcaccec2d";
  };

  checkInputs = [ nose ];

  nativeBuildInputs = [ cython ];
  propagatedBuildInputs = [ numpy scipy scikitlearn joblib ];

  meta = with lib; {
    description = "Hierarchical Density-Based Spatial Clustering of Applications with Noise, a clustering algorithm with a scikit-learn compatible API";
    homepage =  https://github.com/scikit-learn-contrib/hdbscan;
    license = licenses.bsd3;
    maintainers = with maintainers; [ ixxie ];
  };
}
