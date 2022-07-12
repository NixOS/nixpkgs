{ lib
, buildPythonPackage
, fetchFromGitHub
, pythonOlder
, requests
}:

buildPythonPackage rec {
  pname = "meilisearch";
  version = "0.19.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "meilisearch";
    repo = "meilisearch-python";
    rev = "refs/tags/v${version}";
    hash = "sha256-ky5Z1bu+JFpnSGfzaEB6g/nl/F/QJQGVpgb+Jf/o/tM=";
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
