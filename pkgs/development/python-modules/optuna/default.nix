{ lib
, buildPythonPackage
, fetchFromGitHub
<<<<<<< HEAD
, pytestCheckHook
, pythonOlder
, alembic
, boto3
, botorch
, catboost
, cma
, cmaes
, colorlog
, distributed
, fakeredis
, fastai
, lightgbm
, matplotlib
, mlflow
, moto
, numpy
, packaging
, pandas
, plotly
, pytest-xdist
, pytorch-lightning
, pyyaml
, redis
, scikit-learn
, scikit-optimize
, scipy
, setuptools
, shap
, sqlalchemy
, tensorflow
, torch
, torchaudio
, torchvision
, tqdm
, wandb
, wheel
, xgboost
=======
, pytest
, mock
, bokeh
, plotly
, chainer
, xgboost
, mpi4py
, lightgbm
, keras
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
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
}:

buildPythonPackage rec {
  pname = "optuna";
<<<<<<< HEAD
  version = "3.3.0";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "optuna";
    repo = "optuna";
    rev = "refs/tags/v${version}";
    hash = "sha256-uHv8uEJOQO1+AeNSxBtnCt6gDQHLT1RToF4hfolVVX0=";
  };

  nativeBuildInputs = [
    setuptools
    wheel
  ];

  propagatedBuildInputs = [
    alembic
    cmaes
    colorlog
    numpy
    packaging
    sqlalchemy
    tqdm
    pyyaml
  ];

  passthru.optional-dependencies = {
    integration = [
      botorch
      catboost
      cma
      distributed
      fastai
      lightgbm
      mlflow
      pandas
      # pytorch-ignite
      pytorch-lightning
      scikit-learn
      scikit-optimize
      shap
      tensorflow
      torch
      torchaudio
      torchvision
      wandb
      xgboost
    ];
    optional = [
      boto3
      botorch
      matplotlib
      pandas
      plotly
      redis
      scikit-learn
    ];
  };

  preCheck = ''
    export PATH=$out/bin:$PATH
  '';

  nativeCheckInputs = [
    fakeredis
    moto
    pytest-xdist
    pytestCheckHook
    scipy
  ] ++ fakeredis.optional-dependencies.lua
    ++ passthru.optional-dependencies.optional;

  pytestFlagsArray = [
    "-m 'not integration'"
  ];

  disabledTestPaths = [
    # require unpackaged kaleido and building it is a bit difficult
    "tests/visualization_tests"
  ];

  pythonImportsCheck = [
    "optuna"
  ];

  meta = with lib; {
    description = "A hyperparameter optimization framework";
    homepage = "https://optuna.org/";
    changelog = "https://github.com/optuna/optuna/releases/tag/${src.rev}";
    license = licenses.mit;
    maintainers = with maintainers; [ natsukium ];
=======
  version = "3.1.0";
  disabled = isPy27;

  src = fetchFromGitHub {
    owner = "optuna";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-dNS3LEWP/Ul1z60iZirFEX30Frc5ZFQLNTgUkT9vLNQ=";
  };

  nativeCheckInputs = [
    pytest
    mock
    bokeh
    plotly
    chainer
    xgboost
    mpi4py
    lightgbm
    keras
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

  configurePhase = lib.optionalString (! pythonOlder "3.5") ''
    substituteInPlace setup.py \
      --replace "'typing'," ""
  '';

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
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
}
