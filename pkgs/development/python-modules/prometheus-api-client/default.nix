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
  setuptools,
  requests,
}:

buildPythonPackage rec {
  pname = "prometheus-api-client";
  version = "0.6.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "4n4nd";
    repo = "prometheus-api-client-python";
    tag = "v${version}";
    hash = "sha256-Xi3n1Ha6bpfp4KfCh/Zky7bBrXOojuR6BVzPNQ3a18Y=";
  };

  build-system = [ setuptools ];

  dependencies = [
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
    changelog = "https://github.com/4n4nd/prometheus-api-client-python/blob/${src.tag}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = [ ];
  };
}
