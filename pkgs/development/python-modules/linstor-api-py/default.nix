{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  wheel,
  distutils,
}:

buildPythonPackage rec {
  pname = "linstor-api-py";
  version = "1.26.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "LINBIT";
    repo = "linstor-api-py";
    tag = "v${version}";
    hash = "sha256-AQMK838P+l0BKaCSOO/+FxNVN3PZsC05n5zgut86RZs=";
    fetchSubmodules = true;
  };

  build-system = [
    setuptools
    wheel
  ];

  dependencies = [
    distutils
  ];

  pythonImportsCheck = [
    "linstor"
  ];

  meta = {
    description = "LINSTOR Python API";
    homepage = "https://github.com/LINBIT/linstor-api-py";
    changelog = "https://github.com/LINBIT/linstor-api-py/blob/${src.tag}/CHANGELOG.md";
    license = lib.licenses.lgpl3Only;
    maintainers = with lib.maintainers; [ soyouzpanda ];
  };
}
