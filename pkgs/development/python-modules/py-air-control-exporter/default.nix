{ lib
, buildPythonPackage
, click
, fetchPypi
, flask
, isPy27
, nixosTests
, prometheus_client
, py-air-control
, pytestCheckHook
, setuptools-scm
}:

buildPythonPackage rec {
  pname = "py-air-control-exporter";
  version = "0.3.0";
  disabled = isPy27;

  src = fetchPypi {
    inherit pname version;
    sha256 = "ece2e446273542e5c0352c9d6e80d8279132c6ada3649c59e87a711448801a3b";
  };

  nativeBuildInputs = [
    setuptools-scm
  ];

  propagatedBuildInputs = [
    click
    flask
    prometheus_client
    py-air-control
  ];

  checkInputs = [
    pytestCheckHook
  ];

  postPatch = ''
    substituteInPlace setup.py \
      --replace "pytest-runner" ""
    substituteInPlace setup.cfg \
      --replace "--cov=py_air_control_exporter" ""
  '';

  disabledTests = [
    # Tests are outdated
    "test_help"
    "test_unknown_protocol"
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
