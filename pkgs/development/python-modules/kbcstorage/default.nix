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
    version = "0.4.1";
    format = "setuptools";

    src = fetchFromGitHub {
      owner = "keboola";
      repo = pname;
      rev  = version;
      sha256 = "189dzj06vzp7366h2qsfvbjmw9qgl7jbp8syhynn9yvrjqp4k8h3";
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
