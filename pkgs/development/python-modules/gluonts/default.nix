{ lib
, buildPythonPackage
, fetchFromGitHub
, numpy
, pandas
, pydantic
, tqdm
, toolz
, typing-extensions
, pyarrow
, torch
, pytorch-lightning
, protobuf
, scipy
, flask
, orjson
, prophet
, cpflows
, holidays
, numba
, statsmodels
, waitress
, scikit-learn
, pytestCheckHook
, flaky
, pytest-timeout
, ujson
, requests
, pythonOlder
}:

buildPythonPackage rec {
  pname = "gluonts";
  version = "0.13.5";
  format = "pyproject";

  disable = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "awslabs";
    repo = "gluonts";
    rev = "v${version}";
    hash = "sha256-wVrgGM39t+CQfolTE5gKZQQQqRPijdPNj5fbET2NeaU=";
  };

  propagatedBuildInputs = [
    numpy
    pandas
    pydantic
    tqdm
    toolz
    typing-extensions
  ];

  passthru.optional-dependencies = {
    anomaly-evaluation = [
      numba
      scikit-learn
    ];
    arrow = [
      pyarrow
    ];
    artificial-dataset = [
      holidays
    ];
    cpflows = [
      cpflows
    ];
    # [mxnet] extension is not supported, because mxnet is broken on numpy>=1.24:
    # https://github.com/awslabs/gluonts/issues/2509
    # mxnet = [
    #   numpy
    #   mxnet
    # ];
    Prophet = [
      prophet
    ];
    # [R] extension is ommited for now, feel free to add it
    pro = [
      orjson
    ];
    shell = [
      flask
      waitress
    ];
    torch = [
      torch
      pytorch-lightning
      protobuf
      scipy
    ];
  };

  preCheck = ''
    # .gluonts is created in home directory, in build time default $HOME is not writable
    export HOME=$(mktemp -d)
  '';

  nativeCheckInputs = [
    pytestCheckHook
    flaky
    pytest-timeout
    ujson
    requests
  ] ++ lib.flatten (builtins.attrValues passthru.optional-dependencies);

  disabledTestPaths = [
    # touches internet
    "test/ev/test_metrics_compared_to_previous_approach.py"

    # [R] extension tests
    "test/ext/r_forecast"

    # [mxnet] extension tests
    "test/mx"
  ];

  pythonImportsCheck = [ "gluonts" ];

  meta = with lib; {
    description = "Probabilistic time series modeling in Python";
    homepage = "https://github.com/awslabs/gluonts";
    license = licenses.asl20;
    maintainers = with maintainers; [ mbalatsko ];
  };
}
