{ lib
, buildPythonPackage
, fetchpatch
, cython
, numpy
, pytestCheckHook
, scipy
, scikit-learn
, fetchPypi
, joblib
, six
, pythonRelaxDepsHook
}:

buildPythonPackage rec {
  pname = "hdbscan";
  version = "0.8.33";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-V/q8Xw5F9I0kB7NccxGSq8iWN2QR/n5LuDb/oD04+Q0=";
  };

  pythonRemoveDeps = [ "cython" ];
  nativeBuildInputs = [ pythonRelaxDepsHook cython ];
  propagatedBuildInputs = [ numpy scipy scikit-learn joblib six ];
  preCheck = ''
    cd hdbscan/tests
    rm __init__.py
  '';
  nativeCheckInputs = [ pytestCheckHook ];
  disabledTests = [
    # known flaky tests: https://github.com/scikit-learn-contrib/hdbscan/issues/420
    "test_mem_vec_diff_clusters"
    "test_all_points_mem_vec_diff_clusters"
    "test_approx_predict_diff_clusters"
    # another flaky test https://github.com/scikit-learn-contrib/hdbscan/issues/421
    "test_hdbscan_boruvka_balltree_matches"
    # more flaky tests https://github.com/scikit-learn-contrib/hdbscan/issues/570
    "test_hdbscan_boruvka_balltree"
    "test_hdbscan_best_balltree_metric"
  ];

  pythonImportsCheck = [ "hdbscan" ];

  meta = with lib; {
    description = "Hierarchical Density-Based Spatial Clustering of Applications with Noise, a clustering algorithm with a scikit-learn compatible API";
    homepage =  "https://github.com/scikit-learn-contrib/hdbscan";
    license = licenses.bsd3;
  };
}
