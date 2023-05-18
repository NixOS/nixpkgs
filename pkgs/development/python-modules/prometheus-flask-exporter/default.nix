{ lib
, buildPythonPackage
, fetchFromGitHub
, flask
, prometheus-client
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "prometheus-flask-exporter";
  version = "0.22.4";

  src = fetchFromGitHub {
    owner = "rycus86";
    repo = "prometheus_flask_exporter";
    rev = version;
    hash = "sha256-GAQ80J7at8Apqu+DUMN3+rLi/lrNv5Y7w/DKpUN2iu8=";
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
