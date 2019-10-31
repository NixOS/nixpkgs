{ lib
, buildPythonPackage
, fetchPypi
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
, sqlalchemy
, numpy
, scipy
, six
, cliff
, colorlog
, pandas
, alembic
, typing
, pythonOlder
, isPy27
}:

buildPythonPackage rec {
  pname = "optuna";
  version = "0.17.1";
  disabled = isPy27;

  src = fetchPypi {
    inherit pname version;
    sha256 = "3d1d3547340c47f34f3a416a2e0761a0ff887ae8ce06474e84ebcc8600afd438";
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
  ] ++ lib.optionals (pythonOlder "3.5") [ typing ];

  configurePhase = if !(pythonOlder "3.5") then ''
    substituteInPlace setup.py \
      --replace "'typing'" ""
  '' else "";

  checkPhase = ''
    pytest --ignore tests/test_cli.py \
           --ignore tests/integration_tests/test_chainermn.py
  '';

  meta = with lib; {
    description = "A hyperparameter optimization framework";
    homepage = https://optuna.org/;
    license = licenses.mit;
    maintainers = [ maintainers.costrouc ];
  };
}
