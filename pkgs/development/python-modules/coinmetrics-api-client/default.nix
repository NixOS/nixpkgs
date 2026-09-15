{
  lib,
  buildPythonPackage,
  fetchPypi,
  openapi-spec-validator,
  orjson,
  pandas,
  poetry-core,
  polars,
  prance,
  pyarrow,
  pytest-mock,
  pytestCheckHook,
  python-dateutil,
  pyyaml,
  requests,
  tqdm,
  typer,
  websocket-client,
}:

buildPythonPackage rec {
  pname = "coinmetrics-api-client";
  version = "2026.9.2.14";
  pyproject = true;

  __darwinAllowLocalNetworking = true;

  src = fetchPypi {
    inherit version;
    pname = "coinmetrics_api_client";
    hash = "sha256-01qVVuV+Cc17ooGe51+367gFOTSxYhWDm9xnOKkMeho=";
  };

  pythonRelaxDeps = [
    "typer"
    "pandas"
    "websocket-client"
  ];

  build-system = [
    openapi-spec-validator
    poetry-core
    prance
  ];

  dependencies = [
    orjson
    pyarrow
    python-dateutil
    pyyaml
    requests
    tqdm
    typer
    websocket-client
  ];

  optional-dependencies = {
    pandas = [ pandas ];
    polars = [ polars ];
  };

  nativeCheckInputs = [
    pytestCheckHook
    pytest-mock
  ]
  ++ lib.concatAttrValues optional-dependencies;

  pythonImportsCheck = [ "coinmetrics.api_client" ];

  meta = {
    description = "Coin Metrics API v4 client library";
    homepage = "https://coinmetrics.github.io/api-client-python/site/index.html";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ centromere ];
    mainProgram = "coinmetrics";
  };
}
