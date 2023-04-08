{ lib
, buildPythonPackage
, fetchPypi
, orjson
, pandas
, poetry-core
, pytestCheckHook
, pytest-mock
, pythonOlder
, python-dateutil
, requests
, typer
, websocket-client
}:

buildPythonPackage rec {
  pname = "coinmetrics-api-client";
  version = "2023.2.23.0";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-XZNGasNYmN4ulfG18M4n8qTO06kSyLoZQj64LzXdl34=";
  };

  nativeBuildInputs = [
    poetry-core
  ];

  propagatedBuildInputs = [
    orjson
    python-dateutil
    requests
    typer
    websocket-client
  ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-mock
  ] ++ passthru.optional-dependencies.pandas;

  pythonImportsCheck = [
    "coinmetrics.api_client"
  ];

  passthru = {
    optional-dependencies = {
      pandas = [ pandas ];
    };
  };

  meta = with lib; {
    description = "Coin Metrics API v4 client library";
    homepage = "https://coinmetrics.github.io/api-client-python/site/index.html";
    license = licenses.mit;
    maintainers = with maintainers; [ centromere ];
  };
}
