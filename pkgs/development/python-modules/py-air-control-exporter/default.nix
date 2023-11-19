{ lib
, buildPythonPackage
, click
, fetchPypi
, flask
, isPy27
, nixosTests
, prometheus-client
, py-air-control
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "py-air-control-exporter";
  version = "0.3.1";
  disabled = isPy27;

  src = fetchPypi {
    inherit pname version;
    sha256 = "0cwhcyyjzc6wlj7jp5h7fcj1hl03wzrz1if3sg205kh2hfrzzlqq";
  };

  propagatedBuildInputs = [
    click
    flask
    prometheus-client
    py-air-control
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [ "py_air_control_exporter" ];

  passthru.tests = { inherit (nixosTests.prometheus-exporters) py-air-control; };

  meta = with lib; {
    description = "Exports Air Quality Metrics to Prometheus";
    homepage = "https://github.com/urbas/py-air-control-exporter";
    license = licenses.mit;
    maintainers = with maintainers; [ urbas ];
  };
}
