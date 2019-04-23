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
  version = "0.8.19";

  src = fetchPypi {
    inherit pname version;
    sha256 = "7bd74c7bd16540d7f437cf6cb61ceb4d23506f4d040c436d7570d104c1297e31";
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
