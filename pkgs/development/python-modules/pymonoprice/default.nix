{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pyserial,
  pyserial-asyncio-fast,
  pytestCheckHook,
  setuptools,
}:

buildPythonPackage rec {
  pname = "pymonoprice";
  version = "0.5";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "etsinko";
    repo = "pymonoprice";
    tag = version;
    hash = "sha256-kyFOWG/Jvn+h9ludzd2Zul9/lkwPxReH76nnDIGD+fM=";
  };

  build-system = [ setuptools ];

  dependencies = [
    pyserial
    pyserial-asyncio-fast
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "pymonoprice" ];

  meta = {
    description = "Python 3 interface implementation for Monoprice 6 zone amplifier";
    homepage = "https://github.com/etsinko/pymonoprice";
    changelog = "https://github.com/etsinko/pymonoprice/releases/tag/${version}";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.jamiemagee ];
  };
}
