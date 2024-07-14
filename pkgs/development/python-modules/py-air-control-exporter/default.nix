{
  lib,
  buildPythonPackage,
  click,
  fetchPypi,
  flask,
  isPy27,
  nixosTests,
  prometheus-client,
  py-air-control,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "py-air-control-exporter";
  version = "0.3.1";
  format = "setuptools";
  disabled = isPy27;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-GNP/s4MCzgLE08PF8PPnA1AYJHMHliuPpNywL71nkDM=";
  };

  propagatedBuildInputs = [
    click
    flask
    prometheus-client
    py-air-control
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "py_air_control_exporter" ];

  passthru.tests = {
    inherit (nixosTests.prometheus-exporters) py-air-control;
  };

  meta = with lib; {
    description = "Exports Air Quality Metrics to Prometheus";
    mainProgram = "py-air-control-exporter";
    homepage = "https://github.com/urbas/py-air-control-exporter";
    license = licenses.mit;
    maintainers = with maintainers; [ urbas ];
  };
}
