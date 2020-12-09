{ buildPythonPackage, fetchPypi, flask, isPy27, lib, prometheus_client
, py-air-control, pytestCheckHook, pytestcov, pytestrunner, setuptools_scm }:

buildPythonPackage rec {
  pname = "py-air-control-exporter";
  version = "0.1.5";
  disabled = isPy27;

  src = fetchPypi {
    inherit pname version;
    sha256 = "46eff1c801a299cf2ad37e6bd0c579449779cb6a47f1007264bfcabf12739f8b";
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
