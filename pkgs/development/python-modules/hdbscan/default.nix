{ lib
, buildPythonPackage
, cython
, numpy
, nose
, scipy
, scikitlearn
, fetchPypi
, fetchpatch
}:

buildPythonPackage rec {
  pname = "hdbscan";
  version = "0.8.20";

  src = fetchPypi {
    inherit pname version;
    sha256 = "263e9f34db63eec217d50f2ca3e65049c065775dc4095b5ee817824cd2b5b51b";
  };

  patches = [
    # Fix Tests. Drop in release >0.8.20
    (fetchpatch {
      name = "test-rsl-missing-import.patch";
      url = https://github.com/scikit-learn-contrib/hdbscan/commit/e40ccef139e56e38adf7bd6912cd63efd97598f9.patch;
      sha256 = "0cfq4ja7j61h2zwd1jw5gagcz2sg18kjnx29sb0bwa13wfw6fip0";
    })
  ];

  checkInputs = [ nose ];

  propagatedBuildInputs = [ cython numpy scipy scikitlearn ];

  meta = with lib; {
    description = "Hierarchical Density-Based Spatial Clustering of Applications with Noise, a clustering algorithm with a scikit-learn compatible API";
    homepage =  https://github.com/scikit-learn-contrib/hdbscan;
    license = licenses.bsd3;
    maintainers = with maintainers; [ ixxie ];
  };
}
