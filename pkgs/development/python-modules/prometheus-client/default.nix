{ lib
, buildPythonPackage
, fetchFromGitHub
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "prometheus-client";
  version = "0.12.0";

  src = fetchFromGitHub {
    owner = "prometheus";
    repo = "client_python";
    rev = "v${version}";
    sha256 = "1a0kllal5vkkdv325k0mx1mha2l9808mcz4dqx6qrgfskz8c2xjl";
  };

  checkInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [ "prometheus_client" ];

  meta = with lib; {
    description = "Prometheus instrumentation library for Python applications";
    homepage = "https://github.com/prometheus/client_python";
    license = licenses.asl20;
  };
}
