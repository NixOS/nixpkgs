{
  lib,
  buildPythonPackage,
  fetchPypi,
  orjson,
  pandas,
  poetry-core,
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
  version = "2024.8.20.13";
  pyproject = true;

  disabled = pythonOlder "3.9";

  __darwinAllowLocalNetworking = true;

  src = fetchPypi {
    inherit version;
    pname = "coinmetrics_api_client";
    hash = "sha256-IBfHHAmT1BTgA6eMkZf8ggfiknNYp7mfELSRyFARWNk=";
  };

  pythonRelaxDeps = [ "typer" ];

  nativeBuildInputs = [
    poetry-core
  ];

  propagatedBuildInputs = [
    orjson
    python-dateutil
    requests
    typer
    tqdm
    websocket-client
  ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-mock
  ] ++ optional-dependencies.pandas;

  pythonImportsCheck = [ "coinmetrics.api_client" ];

  optional-dependencies = {
    pandas = [ pandas ];
  };

  meta = with lib; {
    description = "Coin Metrics API v4 client library";
    mainProgram = "coinmetrics";
    homepage = "https://coinmetrics.github.io/api-client-python/site/index.html";
    license = licenses.mit;
    maintainers = with maintainers; [ centromere ];
  };
}
