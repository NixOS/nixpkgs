{ lib
, buildPythonPackage
, fetchpatch
, cython
, numpy
, pytestCheckHook
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
  patches = [
    # This patch fixes compatibility with numpy 1.20. It will be in the next release
    # after 0.8.27
    (fetchpatch {
      url = "https://github.com/scikit-learn-contrib/hdbscan/commit/5b67a4fba39c5aebe8187a6a418da677f89a63e0.patch";
      sha256 = "07d7jdwk0b8kgaqkifd529sarji01j1jiih7cfccc5kxmlb5py9h";
    })
  ];

  nativeBuildInputs = [ cython ];
  propagatedBuildInputs = [ numpy scipy scikitlearn joblib six ];
  preCheck = ''
    cd hdbscan/tests
    rm __init__.py
  '';
  checkInputs = [ pytestCheckHook ];

  meta = with lib; {
    description = "Hierarchical Density-Based Spatial Clustering of Applications with Noise, a clustering algorithm with a scikit-learn compatible API";
    homepage =  "https://github.com/scikit-learn-contrib/hdbscan";
    license = licenses.bsd3;
    maintainers = with maintainers; [ ixxie ];
  };
}
