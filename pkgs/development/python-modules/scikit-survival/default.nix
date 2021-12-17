{ lib
, buildPythonPackage
, fetchPypi
, cython
, ecos
, joblib
, numexpr
, numpy
, osqp
, pandas
, scikit-learn
, scipy
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "scikit-survival";
  version = "0.16.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "d3573eb1df9d516c75994a8a82108b6c7a5ca7ea8a9af60b38f3f65c3e227fa7";
  };

  nativeBuildInputs = [
    cython
  ];

  propagatedBuildInputs = [
    ecos
    joblib
    numexpr
    numpy
    osqp
    pandas
    scikit-learn
    scipy
  ];

  pythonImportsCheck = [ "sksurv" ];

  checkInputs = [ pytestCheckHook ];

  # Hack needed to make pytest + cython work
  # https://github.com/NixOS/nixpkgs/pull/82410#issuecomment-827186298
  preCheck = ''
    export HOME=$(mktemp -d)
    cp -r $TMP/$sourceRoot/tests $HOME
    pushd $HOME
  '';
  postCheck = "popd";

  # very long tests, unnecessary for a leaf package
  disabledTests = [
    "test_coxph"
    "test_datasets"
    "test_ensemble_selection"
    "test_minlip"
    "test_pandas_inputs"
    "test_survival_svm"
    "test_tree"
  ];

  meta = with lib; {
    description = "Survival analysis built on top of scikit-learn";
    homepage = "https://github.com/sebp/scikit-survival";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ GuillaumeDesforges ];
  };
}
