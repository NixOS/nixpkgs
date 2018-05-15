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
  version = "0.8.13";

  src = fetchPypi {
    inherit pname version;
    sha256 = "31874db29375816688b5541287a051c9bd768f2499ccf1f6a4d88d266530e2a6";
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
