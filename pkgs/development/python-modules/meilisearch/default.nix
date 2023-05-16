{ lib
, buildPythonPackage
, camel-converter
, fetchFromGitHub
, pythonOlder
, setuptools
, requests
}:

buildPythonPackage rec {
  pname = "meilisearch";
<<<<<<< HEAD
  version = "0.28.2";
=======
  version = "0.26.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "meilisearch";
    repo = "meilisearch-python";
    rev = "refs/tags/v${version}";
<<<<<<< HEAD
    hash = "sha256-S1ZBSkWqCU6EpFqLpxCN1ZNswJroF86+26WeyYPD0S0=";
=======
    hash = "sha256-DhArrKIA9S/huO3QRjZNZ2xOpHybZgj6tIBKfRX6ZYg=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  nativeBuildInputs = [
    setuptools
  ];

  propagatedBuildInputs = [
    camel-converter
    requests
  ] ++ camel-converter.optional-dependencies.pydantic;

  pythonImportsCheck = [
    "meilisearch"
  ];

  # Tests spin up a local server and are not mocking the requests
  doCheck = false;

  meta = with lib; {
    description = "Client for the Meilisearch API";
    homepage = "https://github.com/meilisearch/meilisearch-python";
    changelog = "https://github.com/meilisearch/meilisearch-python/releases/tag/v${version}";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
