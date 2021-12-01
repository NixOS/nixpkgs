{ lib
, buildPythonPackage
, fetchFromGitHub
, flask
, prometheus-client
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "prometheus-flask-exporter";
  version = "0.18.1";

  src = fetchFromGitHub {
    owner = "rycus86";
    repo = "prometheus_flask_exporter";
    rev = version;
    sha256 = "1dwisp681w0f6zf0000rxd3ksdb48zb9mr38qfdqk2ir24y8w370";
  };

  propagatedBuildInputs = [ flask prometheus-client ];

  checkInputs = [ pytestCheckHook ];
  pytestFlagsArray = [ "tests/" ];

  meta = with lib; {
    description = "Prometheus exporter for Flask applications";
    homepage = "https://github.com/rycus86/prometheus_flask_exporter";
    license = licenses.mit;
    maintainers = with maintainers; [ lbpdt ];
  };
}
