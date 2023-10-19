{ stdenv
, lib
, buildPythonPackage
, fetchPypi
, cython
, ecos
, joblib
, numexpr
, numpy
, osqp
, pandas
, setuptools-scm
, scikit-learn
, scipy
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "scikit-survival";
  version = "0.20.0";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-24+8Sociq6u3KnoGSdV5Od5t/OT1uPkv19i3p5ezLjw=";
  };

  nativeBuildInputs = [
    cython
    setuptools-scm
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

  nativeCheckInputs = [ pytestCheckHook ];

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
    broken = (stdenv.isLinux && stdenv.isAarch64);
    description = "Survival analysis built on top of scikit-learn";
    homepage = "https://github.com/sebp/scikit-survival";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ GuillaumeDesforges ];
  };
}
