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
  version = "0.8.23";

  src = fetchPypi {
    inherit pname version;
    sha256 = "ff60c66591452ceb6bdb7592c560a1ebc7e128a02dd3880e048861f7fea7f78d";
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
