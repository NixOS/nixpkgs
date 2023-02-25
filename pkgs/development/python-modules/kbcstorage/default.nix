{ lib
, buildPythonPackage
, fetchFromGitHub

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

    src = fetchFromGitHub {
      owner = "keboola";
      repo = pname;
      rev = "refs/tags/${version}";
      sha256 = "sha256-79v9quhzeNRXcm6Z7BhD76lTZtw+Z0T1yK3zhrdreXw=";
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

    # requires API token and an active keboola bucket
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
      maintainers = with maintainers; [ mrmebelman ];
      license = licenses.mit;
    };
}
