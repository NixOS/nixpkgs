{
  lib,
  boto3,
  botocore,
  buildPythonPackage,
  fetchFromGitHub,
  poetry-core,
  prometheus-api-client,
  pydantic,
  requests,
}:

buildPythonPackage {
  pname = "prometrix";
  version = "0.2.12-unstable-2026-06-08";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "robusta-dev";
    repo = "prometrix";
    # Upstream does not publish tags or releases, see:
    # https://github.com/robusta-dev/prometrix/issues/8
    rev = "4830ebd9726075ac3e12a5644a9e4668c0bba419";
    hash = "sha256-K8IKfI9vxz251+CZ/L/c1oPxgST6fOiCGJCasw+KBFs=";
  };

  pythonRemoveDeps = [
    # Added upstream only to pin a transitive dependency for CVE remediation:
    # https://github.com/robusta-dev/prometrix/commit/9a320185d12c8239a7fda95d78bf928cb0975eb7
    "zipp"
  ];

  build-system = [ poetry-core ];

  dependencies = [
    boto3
    botocore
    prometheus-api-client
    pydantic
    requests
  ];

  # Fixture is missing
  # https://github.com/robusta-dev/prometrix/issues/9
  doCheck = false;

  pythonImportsCheck = [ "prometrix" ];

  meta = {
    description = "Unified Prometheus client";
    longDescription = ''
      This Python package provides a unified Prometheus client that can be used
      to connect to and query various types of Prometheus instances.
    '';
    homepage = "https://github.com/robusta-dev/prometrix";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
}
