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
  version = "0.19.0";
  disabled = isPy27;

  src = fetchPypi {
    inherit pname version;
    sha256 = "cbcdc826915dd07f7df723bec0dd3edd5e61e54c40e7a8b023e19d4434eef602";
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
