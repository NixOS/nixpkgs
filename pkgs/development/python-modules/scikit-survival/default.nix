{
  stdenv,
  lib,
  buildPythonPackage,
  fetchPypi,
  cython,
  ecos,
  joblib,
  numexpr,
  numpy,
  osqp,
  pandas,
  setuptools-scm,
  scikit-learn,
  scipy,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "scikit-survival";
  version = "0.23.0";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-JFI3SDOK74vQdoUOStYlc4e0VHps97KjV3a1NQSN6E0=";
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

  # treat numpy versions as lower bounds, same as setuptools build
  postPatch = ''
    sed -i 's/numpy==/numpy>=/' pyproject.toml
  '';

  # Hack needed to make pytest + cython work
  # https://github.com/NixOS/nixpkgs/pull/82410#issuecomment-827186298
  preCheck = ''
    export HOME=$(mktemp -d)
    cp -r $TMP/$sourceRoot/tests $HOME
    pushd $HOME
  '';
  postCheck = "popd";

  # very long tests, unnecessary for a leaf package
  disabledTests =
    [
      "test_coxph"
      "test_datasets"
      "test_ensemble_selection"
      "test_minlip"
      "test_pandas_inputs"
      "test_survival_svm"
      "test_tree"
    ]
    ++ lib.optional (stdenv.hostPlatform.isDarwin && stdenv.hostPlatform.isAarch64)
      # floating point mismatch on aarch64
      # 27079905.88052468 to far from 27079905.880496684
      "test_coxnet";

  meta = with lib; {
    description = "Survival analysis built on top of scikit-learn";
    homepage = "https://github.com/sebp/scikit-survival";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ GuillaumeDesforges ];
  };
}
