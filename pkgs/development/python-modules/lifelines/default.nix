{
  lib,
  autograd,
  autograd-gamma,
  buildPythonPackage,
  dill,
  fetchFromGitHub,
  flaky,
  formulaic,
  jinja2,
  matplotlib,
  numpy,
  pandas,
  psutil,
  pytestCheckHook,
  scikit-learn,
  scipy,
  setuptools,
  sybil,
}:

buildPythonPackage rec {
  pname = "lifelines";
  version = "0.30.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "CamDavidsonPilon";
    repo = "lifelines";
    tag = "v${version}";
    hash = "sha256-zEkXuv0GmYvvDntgVVHHZdjE04uCKKp2ia+p0zAVB9s=";
  };

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

  nativeCheckInputs = [
    dill
    flaky
    jinja2
    psutil
    pytestCheckHook
    scikit-learn
    sybil
  ];

  pythonImportsCheck = [ "lifelines" ];

  disabledTestPaths = [ "lifelines/tests/test_estimation.py" ];

  disabledTests = [
    "test_datetimes_to_durations_with_different_frequencies"
    # AssertionError
    "test_mice_scipy"
  ];

  meta = {
    description = "Survival analysis in Python";
    homepage = "https://lifelines.readthedocs.io";
    changelog = "https://github.com/CamDavidsonPilon/lifelines/blob/v${version}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ swflint ];
  };
}
