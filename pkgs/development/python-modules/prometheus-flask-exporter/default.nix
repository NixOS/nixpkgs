{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  flask,
  prometheus-client,
  pytestCheckHook,
  setuptools,
}:

buildPythonPackage rec {
  pname = "prometheus-flask-exporter";
  version = "0.23.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "rycus86";
    repo = "prometheus_flask_exporter";
    tag = version;
    hash = "sha256-fWCIthtBiPJwn/Mbbwdv2+1cr9nlpUsPE2mDkaSsfpM=";
  };

  build-system = [ setuptools ];

  dependencies = [
    flask
    prometheus-client
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  enabledTestPaths = [ "tests/" ];

  disabledTests = [
    # AssertionError
    "test_group_by_lambda_is_not_supported"
  ];

  meta = with lib; {
    description = "Prometheus exporter for Flask applications";
    homepage = "https://github.com/rycus86/prometheus_flask_exporter";
    license = licenses.mit;
    maintainers = with maintainers; [ lbpdt ];
  };
}
