{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  cython,
  numpy,
  scipy,
  scikit-learn,
  joblib,
  six,

  # test
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "hdbscan";
  version = "0.8.41";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "scikit-learn-contrib";
    repo = "hdbscan";
    tag = "release-${version}";
    hash = "sha256-4uwWoNkrdLB2KzDAksPupdgkIFBgTahzravOtu1WYws=";
  };

  pythonRemoveDeps = [ "cython" ];

  nativeBuildInputs = [
    cython
    joblib
    numpy
    scikit-learn
    scipy
    six
  ];

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
    # "got an unexpected keyword argument"
    "test_hdbscan_badargs"
  ];

  disabledTestPaths = [
    # joblib.externals.loky.process_executor.BrokenProcessPool:
    "test_branches.py"
  ];

  pythonImportsCheck = [ "hdbscan" ];

  meta = {
    description = "Hierarchical Density-Based Spatial Clustering of Applications with Noise, a clustering algorithm with a scikit-learn compatible API";
    homepage = "https://github.com/scikit-learn-contrib/hdbscan";
    changelog = "https://github.com/scikit-learn-contrib/hdbscan/releases/tag/release-${src.tag}";
    license = lib.licenses.bsd3;
    maintainers = [ ];
  };
}
