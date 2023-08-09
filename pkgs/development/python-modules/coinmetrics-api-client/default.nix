{ lib
, buildPythonPackage
, fetchPypi
, nix-update-script
, orjson
, pandas
, poetry-core
, pytest-mock
, pytestCheckHook
, python-dateutil
, pythonOlder
, pythonRelaxDepsHook
, requests
, typer
, websocket-client
}:

buildPythonPackage rec {
  pname = "coinmetrics-api-client";
  version = "2023.7.11.17";
  format = "pyproject";

  disabled = pythonOlder "3.9";

  __darwinAllowLocalNetworking = true;

  src = fetchPypi {
    inherit version;
    pname = "coinmetrics_api_client";
    hash = "sha256-s5hg9qaa5j/l/qy5DS6f1w5LH2URVyG1Uf02BSIplbc=";
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
    updateScript = nix-update-script { };
  };

  meta = with lib; {
    description = "Coin Metrics API v4 client library";
    homepage = "https://coinmetrics.github.io/api-client-python/site/index.html";
    license = licenses.mit;
    maintainers = with maintainers; [ centromere ];
  };
}
