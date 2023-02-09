{ lib
, buildPythonPackage
, fetchFromGitHub
, aiohttp
, matplotlib
, numpy
, openpyxl
, pandas
, pandas-stubs
, plotly
, pytest-asyncio
, pytest-mock
, pytestCheckHook
, pythonOlder
, requests
, scikit-learn
, tenacity
, tqdm
, typing-extensions
, wandb
, withOptionalDependencies ? false
}:

buildPythonPackage rec {
  pname = "openai";
  version = "0.26.5";
  format = "setuptools";

  disabled = pythonOlder "3.7.1";

  src = fetchFromGitHub {
    owner = "openai";
    repo = "openai-python";
    rev = "v${version}";
    hash = "sha256-eKU+WRFf7f1yH63vcoQ9dVeqhJXBqMJGpk/9AoEgR0M=";
  };

  propagatedBuildInputs = [
    aiohttp
    requests
    tqdm
  ] ++ lib.optionals (pythonOlder "3.8") [
    typing-extensions
  ] ++ lib.optionals withOptionalDependencies (builtins.attrValues {
    inherit (passthru.optional-dependencies) embeddings wandb;
  });

  passthru.optional-dependencies = {
    datalib = [
      numpy
      openpyxl
      pandas
      pandas-stubs
    ];
    embeddings = [
      matplotlib
      plotly
      scikit-learn
      tenacity
    ] ++ passthru.optional-dependencies.datalib;
    wandb = [
      wandb
    ] ++ passthru.optional-dependencies.datalib;
  };

  pythonImportsCheck = [
    "openai"
  ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-asyncio
    pytest-mock
  ];

  pytestFlagsArray = [
    "openai/tests"
  ];

  OPENAI_API_KEY = "sk-foo";

  disabledTestPaths = [
    # Requires a real API key
    "openai/tests/test_endpoints.py"
    "openai/tests/asyncio/test_endpoints.py"
    # openai: command not found
    "openai/tests/test_file_cli.py"
    "openai/tests/test_long_examples_validator.py"
  ];

  meta = with lib; {
    description = "Python client library for the OpenAI API";
    homepage = "https://github.com/openai/openai-python";
    license = licenses.mit;
    maintainers = with maintainers; [ malo ];
  };
}
