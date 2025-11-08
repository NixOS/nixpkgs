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
  version = "0.15.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "maginawin";
    repo = "PySrDaliGateway";
    tag = "v${version}";
    hash = "sha256-qPZxcGDSToFkkXBJKxo9OkcTBr4TZ9cFrcQwBTwKfy8=";
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
