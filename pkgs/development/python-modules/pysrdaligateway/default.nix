{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  wheel,
  cryptography,
  paho-mqtt,
  psutil,
  pytestCheckHook,
  pytest-asyncio,
  pytest-cov,
}:

buildPythonPackage rec {
  pname = "pysrdaligateway";
  version = "0.16.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "maginawin";
    repo = "PySrDaliGateway";
    tag = "v${version}";
    hash = "sha256-V6yc2SGgF6ab9UOSwxGbUh43A/9x7SCTPQDbakoTbd0=";
  };

  build-system = [ setuptools ];

  dependencies = [
    cryptography
    paho-mqtt
    psutil
  ];

  pythonImportsCheck = [ "PySrDaliGateway" ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  meta = {
    changelog = "https://github.com/maginawin/PySrDaliGateway/releases/tag/${src.tag}";
    description = "Python library for Sunricher DALI Gateway (EDA)";
    homepage = "https://github.com/maginawin/PySrDaliGateway";
    license = lib.licenses.asl20;
    maintainers = [ lib.maintainers.dotlambda ];
  };
}
