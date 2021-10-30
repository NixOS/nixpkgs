{ lib
, buildPythonPackage
, fetchFromGitHub
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "prometheus-client";
  version = "0.11.0";

  src = fetchFromGitHub {
    owner = "prometheus";
    repo = "client_python";
    rev = "v${version}";
    sha256 = "14swmy4dgpk6cyjsm2advgc2c8api7xaca1sl7swznblh5fyzgzg";
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
