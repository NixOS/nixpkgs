{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  wheel,
}:

buildPythonPackage rec {
  pname = "openvino-telemetry";
  version = "2025.1.0";
  pyproject = true;

  src = fetchPypi {
    pname = "openvino_telemetry";
    inherit version;
    hash = "sha256-EqKwTNGOg8w9gYuf/1QnSSLhnsokNGFrjz6ykEqctDo=";
  };

  build-system = [
    setuptools
    wheel
  ];

  pythonImportsCheck = [
    "openvino_telemetry"
  ];

  meta = {
    description = "OpenVINO™ Telemetry package for sending statistics with user's consent, used in combination with other OpenVINO™ packages";
    homepage = "https://pypi.org/project/openvino-telemetry/";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ ferrine ];
  };
}
