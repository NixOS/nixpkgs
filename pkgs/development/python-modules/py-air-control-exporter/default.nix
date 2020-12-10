{ buildPythonPackage, fetchPypi, flask, isPy27, lib, prometheus_client
, py-air-control, pytestCheckHook, pytestcov, pytestrunner, setuptools_scm }:

buildPythonPackage rec {
  pname = "py-air-control-exporter";
  version = "0.2.0";
  disabled = isPy27;

  src = fetchPypi {
    inherit pname version;
    sha256 = "2c1bce2423b7452388e35756bef098c123b3cd4a38e8b1302f7297a08e0a9eaa";
  };

  nativeBuildInputs = [ setuptools_scm ];
  checkInputs = [ pytestCheckHook pytestcov pytestrunner ];
  propagatedBuildInputs = [ flask prometheus_client py-air-control ];

  meta = with lib; {
    description = "Exports Air Quality Metrics to Prometheus.";
    homepage = "https://github.com/urbas/py-air-control-exporter";
    license = licenses.mit;
    maintainers = with maintainers; [ urbas ];
  };
}
