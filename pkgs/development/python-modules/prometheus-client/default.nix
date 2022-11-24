{ lib
, buildPythonPackage
, fetchFromGitHub
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "prometheus-client";
  version = "0.15.0";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "prometheus";
    repo = "client_python";
    rev = "refs/tags/v${version}";
    hash = "sha256-LabvQMNiRH4jclMnN0P4M3w25NQasNQEu1HWvRDQQ2o=";
  };

  checkInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "prometheus_client"
  ];

  meta = with lib; {
    description = "Prometheus instrumentation library for Python applications";
    homepage = "https://github.com/prometheus/client_python";
    license = licenses.asl20;
    maintainers = with maintainers; [ ];
  };
}
