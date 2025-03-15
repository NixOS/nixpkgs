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
  pythonOlder,
  requests,
  tqdm,
  typer,
  websocket-client,
}:

buildPythonPackage rec {
  pname = "coinmetrics-api-client";
  version = "2025.3.12.17";
  pyproject = true;

  disabled = pythonOlder "3.9";

  __darwinAllowLocalNetworking = true;

  src = fetchPypi {
    inherit version;
    pname = "coinmetrics_api_client";
    hash = "sha256-vmmsslR+4fhNqkzvXB87ilc6vQ+b9PdMlj6LEV7ms7A=";
  };

  pythonRelaxDeps = [ "typer" ];

  build-system = [ poetry-core ];

  dependencies = [
    orjson
    python-dateutil
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
  ] ++ lib.flatten (builtins.attrValues optional-dependencies);

  pythonImportsCheck = [ "coinmetrics.api_client" ];

  meta = with lib; {
    description = "Coin Metrics API v4 client library";
    homepage = "https://coinmetrics.github.io/api-client-python/site/index.html";
    license = licenses.mit;
    maintainers = with maintainers; [ centromere ];
    mainProgram = "coinmetrics";
  };
}
