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
  version = "0.8.28";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-7tr3Hy87vt/Ew42hrUiXRUzl69R5LhponJecKFPtwFo=";
  };
  patches = [
    # should be included in next release
    (fetchpatch {
      name = "joblib-1.2.0-compat.patch";
      url = "https://github.com/scikit-learn-contrib/hdbscan/commit/d829c639923f6866e1917e46ddbde45b513913f3.patch";
      excludes = [
        "docs/basic_hdbscan.rst"
        "docs/how_hdbscan_works.rst"
      ];
      sha256 = "sha256-t0D4OsHEcMwmBZM8Mk1N0uAKi6ra+TOzEks9/efsvWI=";
    })
  ];

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
    maintainers = with maintainers; [ ixxie ];
  };
}
