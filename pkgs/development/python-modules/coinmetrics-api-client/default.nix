{
  lib,
  buildPythonPackage,
  fetchPypi,
  orjson,
  pandas,
  poetry-core,
  polars,
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
  version = "2026.2.9.18";
  pyproject = true;

  __darwinAllowLocalNetworking = true;

  src = fetchPypi {
    inherit version;
    pname = "coinmetrics_api_client";
    hash = "sha256-5R/Z/FItszcNAdwHkhzr/HWqQBbXsYf9Hub+HGdBEGo=";
  };

  pythonRelaxDeps = [ "typer" ];

  build-system = [ poetry-core ];

  dependencies = [
    orjson
    python-dateutil
    pyyaml
    requests
    typer
    tqdm
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
