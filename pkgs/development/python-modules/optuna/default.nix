{ lib
, buildPythonPackage
, fetchFromGitHub
, pytest
, mock
, bokeh
, plotly
, chainer
, xgboost
, mpi4py
, lightgbm
, Keras
, mxnet
, scikit-optimize
, tensorflow
, cma
, sqlalchemy
, numpy
, scipy
, six
, cliff
, colorlog
, pandas
, alembic
, tqdm
, typing
, pythonOlder
, isPy27
}:

buildPythonPackage rec {
  pname = "optuna";
  version = "2.10.0";
  disabled = isPy27;

  src = fetchFromGitHub {
    owner = "optuna";
    repo = pname;
    rev = "v${version}";
    sha256 = "0fha0pwxq6n3mbpvpz3vk8hh61zqncj5cnq063kzfl5d8rd48vcd";
  };

  checkInputs = [
    pytest
    mock
    bokeh
    plotly
    chainer
    xgboost
    mpi4py
    lightgbm
    Keras
    mxnet
    scikit-optimize
    tensorflow
    cma
  ];

  propagatedBuildInputs = [
    sqlalchemy
    numpy
    scipy
    six
    cliff
    colorlog
    pandas
    alembic
    tqdm
  ] ++ lib.optionals (pythonOlder "3.5") [
    typing
  ];

  configurePhase = if !(pythonOlder "3.5") then ''
    substituteInPlace setup.py \
      --replace "'typing'," ""
  '' else "";

  checkPhase = ''
    pytest --ignore tests/test_cli.py \
           --ignore tests/integration_tests/test_chainermn.py \
           --ignore tests/integration_tests/test_pytorch_lightning.py \
           --ignore tests/integration_tests/test_pytorch_ignite.py \
           --ignore tests/integration_tests/test_fastai.py
  '';

  meta = with lib; {
    broken = true;  # Dashboard broken, other build failures.
    description = "A hyperparameter optimization framework";
    homepage = "https://optuna.org/";
    license = licenses.mit;
    maintainers = [ maintainers.costrouc ];
  };
}
