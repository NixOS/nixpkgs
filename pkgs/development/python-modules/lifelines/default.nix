{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,
  fetchpatch,

  # build-system
  setuptools,

  # dependencies
  autograd,
  autograd-gamma,
  formulaic,
  matplotlib,
  numpy,
  pandas,
  scipy,

  # tests
  dill,
  flaky,
  jinja2,
  psutil,
  pytestCheckHook,
  scikit-learn,
  sybil,
}:

buildPythonPackage (finalAttrs: {
  pname = "lifelines";
  version = "0.30.3";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "CamDavidsonPilon";
    repo = "lifelines";
    tag = "v${finalAttrs.version}";
    hash = "sha256-A9MsQN/JGCQ4cYNIZI5LBKpRb44uI/SM8eT4/nKpsXQ=";
  };

  patches = [
    # pandas 3.0 compatibility
    # https://github.com/CamDavidsonPilon/lifelines/pull/1684
    (fetchpatch {
      name = "pandas-3-compat.patch";
      url = "https://github.com/CamDavidsonPilon/lifelines/commit/755db6f1e018056b14282885e010274d9f91755a.patch";
      hash = "sha256-T9NLs3R1+G6gWam+DU/rCOYVyQpq9YjkoWgCh2KUxm4=";
    })
  ];

  build-system = [ setuptools ];

  dependencies = [
    autograd
    autograd-gamma
    formulaic
    matplotlib
    numpy
    pandas
    scipy
  ];

  pythonImportsCheck = [ "lifelines" ];

  nativeCheckInputs = [
    dill
    flaky
    jinja2
    psutil
    pytestCheckHook
    scikit-learn
    sybil
  ];

  disabledTests = lib.optionals stdenv.hostPlatform.isDarwin [
    # AssertionError: Not equal to tolerance rtol=0.01, atol=0
    "test_score_method_returns_same_value_for_unpenalized_models"
    "test_that_adding_strata_will_change_c_index"
  ];

  meta = {
    description = "Survival analysis in Python";
    homepage = "https://lifelines.readthedocs.io";
    changelog = "https://github.com/CamDavidsonPilon/lifelines/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ swflint ];
  };
})
