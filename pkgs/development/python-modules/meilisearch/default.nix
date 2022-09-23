{ lib
, buildPythonPackage
, fetchFromGitHub
, pythonOlder
, requests
}:

buildPythonPackage rec {
  pname = "meilisearch";
  version = "0.19.1";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "meilisearch";
    repo = "meilisearch-python";
    rev = "refs/tags/v${version}";
    hash = "sha256-/z1UtZJE91dUHogXCbCv8nI8bd26HYVi1OzUV3sArJU=";
  };

  propagatedBuildInputs = [
    requests
  ];

  pythonImportsCheck = [
    "meilisearch"
  ];

  # Tests spin up a local server and are not mocking the requests
  doCheck = false;

  meta = with lib; {
    description = "Client for the Meilisearch API";
    homepage = "https://github.com/meilisearch/meilisearch-python";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
