{ lib, buildPythonPackage, fetchPypi, isPy27
, fetchpatch
, pandas
, pytestCheckHook
, scikitlearn
}:

buildPythonPackage rec {
  pname = "imbalanced-learn";
  version = "0.7.0";
  disabled = isPy27; # scikit-learn>=0.21 doesn't work on python2

  src = fetchPypi {
    inherit pname version;
    sha256 = "da59de0d1c0fa66f62054dd9a0a295a182563aa1abbb3bf9224a3678fcfe8fa4";
  };

  patches = [
    # Fix compatibility with scikit-learn 0.24. This patch will be included in releases of
    # imbalanced-learn after 0.7.0
    (fetchpatch {
      url = "https://github.com/scikit-learn-contrib/imbalanced-learn/commit/dc4051fe0011c68d900be05971b71016d4ad9e90.patch";
      sha256 = "1rv61k9wv4q37a0v943clr8fflcg9ly530smgndgkjlxkyzw6swh";
      excludes = ["doc/conf.py" "build_tools/*" "azure-pipelines.yml"];
    })
  ];

  propagatedBuildInputs = [ scikitlearn ];
  checkInputs = [ pytestCheckHook pandas ];
  preCheck = ''
    export HOME=$TMPDIR
  '';
  disabledTests = [
    "estimator"
    "classification"
    "_generator"
    "show_versions"
    "test_make_imbalanced_iris"
    "test_rusboost[SAMME.R]"
  ];

  meta = with lib; {
    description = "Library offering a number of re-sampling techniques commonly used in datasets showing strong between-class imbalance";
    homepage = "https://github.com/scikit-learn-contrib/imbalanced-learn";
    license = licenses.mit;
    maintainers = [ maintainers.rmcgibbo ];
  };
}
