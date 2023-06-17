{ lib
, buildPythonPackage
, fetchPypi
, nix-update-script
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
  version = "2023.5.26.17";
  format = "pyproject";

  disabled = pythonOlder "3.9";

  __darwinAllowLocalNetworking = true;

  src = fetchPypi {
    inherit version;
    pname = "coinmetrics_api_client";
    hash = "sha256-GCHXraeH6WWTlCnw9B1Xwtb6jwcxcvW1siy2T/8x14Q=";
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
    updateScript = nix-update-script { };
  };

  meta = with lib; {
    description = "Coin Metrics API v4 client library";
    homepage = "https://coinmetrics.github.io/api-client-python/site/index.html";
    license = licenses.mit;
    maintainers = with maintainers; [ centromere ];
  };
}
