{ lib
, buildPythonPackage
, fetchFromGitHub
, flask
, prometheus-client
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "prometheus-flask-exporter";
  version = "0.20.3";

  src = fetchFromGitHub {
    owner = "rycus86";
    repo = "prometheus_flask_exporter";
    rev = version;
    sha256 = "sha256-l9Iw9fvXQMXzq1y/4Dml8uLPJWyqX6SDIXptJVw3cVQ=";
  };

  propagatedBuildInputs = [ flask prometheus-client ];

  nativeCheckInputs = [ pytestCheckHook ];
  pytestFlagsArray = [ "tests/" ];

  meta = with lib; {
    description = "Prometheus exporter for Flask applications";
    homepage = "https://github.com/rycus86/prometheus_flask_exporter";
    license = licenses.mit;
    maintainers = with maintainers; [ lbpdt ];
  };
}
