{
  stdenv,
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  cython,
  ecos,
  eigen,
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
  version = "0.23.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "sebp";
    repo = "scikit-survival";
    rev = "refs/tags/v${version}";
    hash = "sha256-6902chXALa73/kTJ5UwV4CrB7/7wn+QXKpp2ej/Dnk8=";
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

  # can remove scikit-learn after 0.23.1
  postPatch = ''
    ln -s ${lib.getInclude eigen}/include/eigen3/Eigen \
      sksurv/linear_model/src/eigen
    sed -i -e 's/numpy>=2.0.0/numpy/' \
       -e 's/scikit-learn~=1.4.0/scikit-learn/' pyproject.toml
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
