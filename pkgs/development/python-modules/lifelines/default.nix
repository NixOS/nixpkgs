{ lib
, buildPythonPackage
, fetchFromGitHub
, pytestCheckHook
, numpy
, scipy
, pandas
, matplotlib
, autograd
, autograd-gamma
, formulaic
, scikit-learn
, sybil
, flaky
, jinja2
, dill
, psutil
}:

buildPythonPackage rec {
  pname = "lifelines";
  version = "0.27.4";

  src = fetchFromGitHub {
    owner = "CamDavidsonPilon";
    repo = "lifelines";
    rev = "v${version}";
    sha256 = "sha256-KDoXplqkTsk85dmcTBhbj2GDcC4ry+2z5C2QHAnBTw4=";
  };

  propagatedBuildInputs = [
    numpy
    scipy
    pandas
    matplotlib
    autograd
    autograd-gamma
    formulaic
  ];

  pythonImportsCheck = [ "lifelines" ];

  checkInputs = [
    dill
    flaky
    jinja2
    psutil
    pytestCheckHook
    scikit-learn
    sybil
  ];

  disabledTestPaths = [
    "lifelines/tests/test_estimation.py"
  ];

  meta = {
    homepage = "https://lifelines.readthedocs.io";
    description = "Survival analysis in Python";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ swflint ];
  };
}
