{ buildPythonPackage, fetchPypi, flask, isPy27, lib, prometheus_client
, py-air-control, pytestCheckHook, pytestcov, pytestrunner, setuptools_scm }:

buildPythonPackage rec {
  pname = "py-air-control-exporter";
  version = "0.1.4";
  disabled = isPy27;

  src = fetchPypi {
    inherit pname version;
    sha256 = "1f13d3mlj6c3xvkclimahx7gpqqn8z56lh4kwy1d3gkjm7zs9zw9";
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
