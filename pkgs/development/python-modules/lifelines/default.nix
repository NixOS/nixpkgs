{ lib
, autograd
, autograd-gamma
, buildPythonPackage
, dill
, fetchFromGitHub
, flaky
, formulaic
, jinja2
, matplotlib
, numpy
, pandas
, psutil
, pytestCheckHook
, pythonOlder
, scikit-learn
, scipy
, sybil
}:

buildPythonPackage rec {
  pname = "lifelines";
  version = "0.27.8";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "CamDavidsonPilon";
    repo = "lifelines";
    rev = "refs/tags/v${version}";
    hash = "sha256-2AjqN4TtBY1KtgFlY0E2UcFUHniHe2Hge+JaUQd4gO8=";
  };

  propagatedBuildInputs = [
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

  pythonImportsCheck = [
    "lifelines"
  ];

  disabledTestPaths = [
    "lifelines/tests/test_estimation.py"
  ];

  disabledTests = [
    "test_datetimes_to_durations_with_different_frequencies"
  ];

  meta = with lib; {
    description = "Survival analysis in Python";
    homepage = "https://lifelines.readthedocs.io";
    changelog = "https://github.com/CamDavidsonPilon/lifelines/blob/v${version}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ swflint ];
  };
}
