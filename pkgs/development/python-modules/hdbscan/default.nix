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
  version = "0.8.20";

  src = fetchPypi {
    inherit pname version;
    sha256 = "263e9f34db63eec217d50f2ca3e65049c065775dc4095b5ee817824cd2b5b51b";
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
