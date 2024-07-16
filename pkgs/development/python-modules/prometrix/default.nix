{
  boto3,
  botocore,
  buildPythonPackage,
  dateparser,
  fetchPypi,
  lib,
  matplotlib,
  numpy,
  pandas,
  poetry-core,
  prometheus-api-client,
  pydantic_1,
  requests,
}:

buildPythonPackage rec {
  pname = "prometrix";
  version = "0.1.18";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-PqV0zMFmBPcLPn2YexIJZ7f2IDPJBumu843rLnTBXpI=";
  };

  build-system = [ poetry-core ];

  pythonRelaxDeps = [
    "pydantic"
    "urllib3"
  ];

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
  ];

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
  };
}
