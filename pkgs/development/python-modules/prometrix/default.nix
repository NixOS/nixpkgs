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
  pydantic_1,
  requests,
  zipp,
}:

buildPythonPackage {
  pname = "prometrix";
  version = "0.2.9-unstable-2026-03-01";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "robusta-dev";
    repo = "prometrix";
    # https://github.com/robusta-dev/prometrix/issues/19
    rev = "498c0010d961454af63d2898bdbe98bd0089a087";
    hash = "sha256-bdYoCePUfTrz915kkXyM0k7vW+yXy8ZqKMEET39o2E8=";
  };

  pythonRelaxDeps = [
    "pillow"
    "prometheus-api-client"
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
    pydantic_1
    requests
    zipp
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
