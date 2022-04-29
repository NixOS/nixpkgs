{ lib
, buildPythonPackage
, fetchFromGitHub
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "prometheus-client";
  version = "0.13.1";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "prometheus";
    repo = "client_python";
    rev = "v${version}";
    sha256 = "sha256-1sMnlUOvvdlUuh288UalAdlf0a1mpnM+Y/upwlnL1H8=";
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
