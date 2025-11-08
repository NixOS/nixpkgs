{
  lib,
  azure-storage-blob,
  boto3,
  buildPythonPackage,
  fetchFromGitHub,
  python-dotenv,
  pythonOlder,
  requests,
  responses,
  setuptools,
  setuptools-git-versioning,
  setuptools-scm,
  urllib3,
  google-auth,
  google-cloud-storage,
}:

buildPythonPackage rec {
  pname = "sapi-python-client";
  version = "0.9.3";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "keboola";
    repo = "sapi-python-client";
    tag = version;
    hash = "sha256-VNIi7YYtgPSpulY7W+fNrlVxDMgbo4Urxp8adLqESn8=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail "urllib3<2.0.0" "urllib3"
  '';

  build-system = [
    setuptools
    setuptools-git-versioning
    setuptools-scm
  ];

  pythonRelaxDeps = [
    "google-cloud-storage"
    "google-auth"
  ];

  dependencies = [
    azure-storage-blob
    boto3
    python-dotenv
    requests
    responses
    urllib3
    google-auth
    google-cloud-storage
  ];

  # Requires API token and an active Keboola bucket
  # ValueError: Root URL is required.
  doCheck = false;

  pythonImportsCheck = [
    "kbcstorage"
    "kbcstorage.buckets"
    "kbcstorage.client"
    "kbcstorage.tables"
  ];

  meta = {
    description = "Keboola Connection Storage API client";
    homepage = "https://github.com/keboola/sapi-python-client";
    changelog = "https://github.com/keboola/sapi-python-client/releases/tag/${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ mrmebelman ];
  };
}
