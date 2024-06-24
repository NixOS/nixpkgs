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
  unittestCheckHook,
  urllib3,
}:

buildPythonPackage rec {
  pname = "sapi-python-client";
  version = "0.8.0";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "keboola";
    repo = "sapi-python-client";
    rev = "refs/tags/${version}";
    hash = "sha256-Xc4VD91Nhnj0UyWHpdwEaETJVH8Ue6/kuiKEMaiSR0g=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail "urllib3<2.0.0" "urllib3"
  '';

  nativeBuildInputs = [
    setuptools
    setuptools-git-versioning
    setuptools-scm
  ];

  propagatedBuildInputs = [
    azure-storage-blob
    boto3
    python-dotenv
    requests
    responses
    urllib3
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

  meta = with lib; {
    description = "Keboola Connection Storage API client";
    homepage = "https://github.com/keboola/sapi-python-client";
    changelog = "https://github.com/keboola/sapi-python-client/releases/tag/${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ mrmebelman ];
  };
}
