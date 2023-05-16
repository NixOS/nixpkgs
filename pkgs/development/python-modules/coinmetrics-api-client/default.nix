{ lib
, buildPythonPackage
, fetchPypi
, nix-update-script
, orjson
, pandas
, poetry-core
<<<<<<< HEAD
, pytest-mock
, pytestCheckHook
, python-dateutil
, pythonOlder
, pythonRelaxDepsHook
, requests
, tqdm
=======
, pytestCheckHook
, pytest-mock
, pythonOlder
, python-dateutil
, requests
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, typer
, websocket-client
}:

buildPythonPackage rec {
  pname = "coinmetrics-api-client";
<<<<<<< HEAD
  version = "2023.8.30.20";
=======
  version = "2023.5.2.20";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  format = "pyproject";

  disabled = pythonOlder "3.9";

  __darwinAllowLocalNetworking = true;

  src = fetchPypi {
    inherit version;
    pname = "coinmetrics_api_client";
<<<<<<< HEAD
    hash = "sha256-zi9hFpmRILfWXA9eLGbzt/+v3l1wykZz10GUuH20hzE=";
  };

  pythonRelaxDeps = [
    "typer"
  ];

  nativeBuildInputs = [
    poetry-core
    pythonRelaxDepsHook
=======
    hash = "sha256-20+qoCaSNGw4DVlW3USrSkg3fckqF77TQ7wmSsuZ3ek=";
  };

  nativeBuildInputs = [
    poetry-core
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  ];

  propagatedBuildInputs = [
    orjson
    python-dateutil
    requests
    typer
<<<<<<< HEAD
    tqdm
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
<<<<<<< HEAD
      pandas = [
        pandas
      ];
=======
      pandas = [ pandas ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
