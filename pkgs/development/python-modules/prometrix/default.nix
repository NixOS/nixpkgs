{
  lib,
  boto3,
  botocore,
  buildPythonPackage,
  dateparser,
  fetchFromGitHub,
  matplotlib,
  numpy,
  pandas,
  poetry-core,
  prometheus-api-client,
  pydantic,
  requests,
}:

buildPythonPackage rec {
  pname = "prometrix";
  version = "0.1.18-unstable-2024-04-30";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "robusta-dev";
    repo = "prometrix";
    # https://github.com/robusta-dev/prometrix/issues/19
    rev = "35128847d46016b88455e0a98f0eeec08d042107";
    hash = "sha256-g8ZqgL9ETVwpKLMQS7s7A4GpSGfaFEDLOr8JBvFl2C4=";
  };

  pythonRelaxDeps = [
    "pydantic"
    "urllib3"
  ];

  build-system = [ poetry-core ];

  dependencies = [
    boto3
    botocore
    dateparser
    matplotlib
    numpy
    pandas
    prometheus-api-client
    pydantic
    requests
  ];

  # Fixture is missing
  # https://github.com/robusta-dev/prometrix/issues/9
  doCheck = false;

  pythonImportsCheck = [ "prometrix" ];

  meta = with lib; {
    description = "Unified Prometheus client";
    longDescription = ''
      This Python package provides a unified Prometheus client that can be used
      to connect to and query various types of Prometheus instances.
    '';
    homepage = "https://github.com/robusta-dev/prometrix";
    license = licenses.mit;
    maintainers = with maintainers; [ azahi ];
    # prometheus-api-client 0.5.5 is not working
    # https://github.com/robusta-dev/prometrix/issues/14
    broken = versionAtLeast prometheus-api-client.version "0.5.3";
  };
}
