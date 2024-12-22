{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  dateparser,
  httmock,
  matplotlib,
  numpy,
  pandas,
  requests,
}:

buildPythonPackage rec {
  pname = "prometheus-api-client";
  version = "0.5.5";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "4n4nd";
    repo = "prometheus-api-client-python";
    rev = "refs/tags/v${version}";
    hash = "sha256-tUu0+ZUOFxBCj//lHhNm88rhFbS01j1x508+nqIkCfQ=";
  };

  propagatedBuildInputs = [
    dateparser
    matplotlib
    numpy
    pandas
    requests
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  checkInputs = [ httmock ];

  disabledTestPaths = [ "tests/test_prometheus_connect.py" ];

  pythonImportsCheck = [ "prometheus_api_client" ];

  meta = with lib; {
    description = "Python wrapper for the Prometheus HTTP API";
    longDescription = ''
      The prometheus-api-client library consists of multiple modules which
      assist in connecting to a Prometheus host, fetching the required metrics
      and performing various aggregation operations on the time series data.
    '';
    homepage = "https://github.com/4n4nd/prometheus-api-client-python";
    changelog = "https://github.com/4n4nd/prometheus-api-client-python/blob/${src.rev}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ azahi ];
  };
}
