{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  cryptography,
  paho-mqtt,
  psutil,
}:

buildPythonPackage rec {
  pname = "pysrdaligateway";
  version = "0.20.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "maginawin";
    repo = "PySrDaliGateway";
    tag = "v${version}";
    hash = "sha256-D98hT87xcLxwOKHgd0M4wIdQIrojxYhtEFlw3hkE2FI=";
  };

  build-system = [ setuptools ];

  dependencies = [
    cryptography
    paho-mqtt
    psutil
  ];

  pythonImportsCheck = [ "PySrDaliGateway" ];

  # upstream "relies on manual integration testing with physical DALI hardware"
  doCheck = false;

  meta = {
    changelog = "https://github.com/maginawin/PySrDaliGateway/releases/tag/${src.tag}";
    description = "Python library for Sunricher DALI Gateway (EDA)";
    homepage = "https://github.com/maginawin/PySrDaliGateway";
    license = lib.licenses.asl20;
    maintainers = [ lib.maintainers.dotlambda ];
  };
}
