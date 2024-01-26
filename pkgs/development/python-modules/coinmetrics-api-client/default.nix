{ lib
, buildPythonPackage
, fetchPypi
, orjson
, pandas
, poetry-core
, pytest-mock
, pytestCheckHook
, python-dateutil
, pythonOlder
, pythonRelaxDepsHook
, requests
, tqdm
, typer
, websocket-client
}:

buildPythonPackage rec {
  pname = "coinmetrics-api-client";
  version = "2024.1.17.17";
  pyproject = true;

  disabled = pythonOlder "3.9";

  __darwinAllowLocalNetworking = true;

  src = fetchPypi {
    inherit version;
    pname = "coinmetrics_api_client";
    hash = "sha256-mYA67oiWWvEdNU2MrjtOPyDW3LbxH/mgh+MOuZg2ljo=";
  };

  pythonRelaxDeps = [
    "typer"
  ];

  nativeBuildInputs = [
    poetry-core
    pythonRelaxDepsHook
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
  ] ++ passthru.optional-dependencies.pandas;

  pythonImportsCheck = [
    "coinmetrics.api_client"
  ];

  passthru = {
    optional-dependencies = {
      pandas = [
        pandas
      ];
    };
  };

  meta = with lib; {
    description = "Coin Metrics API v4 client library";
    homepage = "https://coinmetrics.github.io/api-client-python/site/index.html";
    license = licenses.mit;
    maintainers = with maintainers; [ centromere ];
  };
}
