{ lib
, buildPythonPackage
, fetchFromGitHub
, matplotlib
, numpy
, openpyxl
, pandas
, pandas-stubs
, plotly
, pytest-mock
, pytestCheckHook
, pythonOlder
, requests
, scikit-learn
, tenacity
, tqdm
, typing-extensions
, wandb
}:

buildPythonPackage rec {
  pname = "openai";
  version = "0.23.1";
  format = "setuptools";

  disabled = pythonOlder "3.7.1";

  src = fetchFromGitHub {
    owner = "openai";
    repo = "openai-python";
    rev = "v${version}";
    hash = "sha256-4RdER6ecvHGXTLZ1GnBNI1hIETI8O/t+kuOXiQhMigs=";
  };

  propagatedBuildInputs = [
    numpy
    openpyxl
    pandas
    pandas-stubs
    requests
    tqdm
    typing-extensions
  ];

  passthru.optional-dependencies = {
    wandb = [
      wandb
    ];
    embeddings = [
      matplotlib
      plotly
      scikit-learn
      tenacity
    ];
  };

  pythonImportsCheck = [
    "openai"
  ];

  checkInputs = [
    pytestCheckHook
    pytest-mock
  ];

  pytestFlagsArray = [
    "openai/tests"
  ];

  OPENAI_API_KEY = "sk-foo";

  disabledTestPaths = [
    # Requires a real API key
    "openai/tests/test_endpoints.py"
    "openai/tests/test_file_cli.py"
  ];

  meta = with lib; {
    description = "Python client library for the OpenAI API";
    homepage = "https://github.com/openai/openai-python";
    license = licenses.mit;
    maintainers = with maintainers; [ malo ];
  };
}
