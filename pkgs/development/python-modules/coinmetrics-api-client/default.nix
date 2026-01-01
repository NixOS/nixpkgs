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
<<<<<<< HEAD
  version = "2025.12.16.20";
=======
  version = "2025.10.21.15";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  pyproject = true;

  __darwinAllowLocalNetworking = true;

  src = fetchPypi {
    inherit version;
    pname = "coinmetrics_api_client";
<<<<<<< HEAD
    hash = "sha256-FnoaLUU+x6uOlGdFhx02z/rlpqrHHt7T8TTPmeE0I68=";
=======
    hash = "sha256-OtC6Sy32faZAZqMVUure4RmPj2LCe4Ifwy+5xmZ0g8U=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
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
<<<<<<< HEAD
  ++ lib.concatAttrValues optional-dependencies;

  pythonImportsCheck = [ "coinmetrics.api_client" ];

  meta = {
    description = "Coin Metrics API v4 client library";
    homepage = "https://coinmetrics.github.io/api-client-python/site/index.html";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ centromere ];
=======
  ++ lib.flatten (builtins.attrValues optional-dependencies);

  pythonImportsCheck = [ "coinmetrics.api_client" ];

  meta = with lib; {
    description = "Coin Metrics API v4 client library";
    homepage = "https://coinmetrics.github.io/api-client-python/site/index.html";
    license = licenses.mit;
    maintainers = with maintainers; [ centromere ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    mainProgram = "coinmetrics";
  };
}
