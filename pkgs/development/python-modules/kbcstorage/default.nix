{ lib
, buildPythonPackage
, fetchFromGitHub
, pythonOlder

# build
, setuptools
, setuptools-git-versioning
, setuptools-scm

# propagates
, azure-storage-blob
, boto3
, requests

# tests
, responses
, unittestCheckHook
}:
buildPythonPackage rec {
  pname = "sapi-python-client";
  version = "0.7.1";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "keboola";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-74sChw6eMkBtfHV6hiaaLNOr/J0Sa73LB93Z8muLaiI=";
  };

  nativeBuildInputs = [
    setuptools
    setuptools-git-versioning
    setuptools-scm
  ];

  propagatedBuildInputs = [
    azure-storage-blob
    boto3
    requests
  ];

  # Requires API token and an active Keboola bucket
  # ValueError: Root URL is required.
  doCheck = false;

  nativeCheckInputs = [
    unittestCheckHook
    responses
  ];

  pythonImportsCheck = [
    "kbcstorage"
    "kbcstorage.buckets"
    "kbcstorage.client"
    "kbcstorage.tables"
  ];

  meta = with lib; {
    description = "Keboola Connection Storage API client";
    homepage = "https://github.com/keboola/sapi-python-client";
    changelog = "https://github.com/keboola/sapi-python-client/releases/tag/${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ mrmebelman ];
  };
}
