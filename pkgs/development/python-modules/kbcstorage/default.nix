{ lib
, buildPythonPackage
, fetchFromGitHub
, pythonOlder

# build
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
  version = "0.5.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "keboola";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-79v9quhzeNRXcm6Z7BhD76lTZtw+Z0T1yK3zhrdreXw=";
  };

  SETUPTOOLS_SCM_PRETEND_VERSION = version;

  nativeBuildInputs = [
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
