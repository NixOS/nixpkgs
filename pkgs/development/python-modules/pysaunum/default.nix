{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  pymodbus,
  pytestCheckHook,
  pytest-asyncio,
  pytest-timeout,
}:

buildPythonPackage (finalAttrs: {
  pname = "pysaunum";
  version = "0.6.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "mettolen";
    repo = "pysaunum";
    tag = "v${finalAttrs.version}";
    hash = "sha256-pyyiuBJ95bnhsM3X/jPdxepP/S0kx3MVJHwKUPXRBzM=";
  };

  build-system = [ setuptools ];

  dependencies = [ pymodbus ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-asyncio
    pytest-timeout
  ];

  pythonImportsCheck = [ "pysaunum" ];

  meta = {
    description = "Python library for controlling Saunum sauna controllers via Modbus TCP";
    homepage = "https://github.com/mettolen/pysaunum";
    changelog = "https://github.com/mettolen/pysaunum/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.jamiemagee ];
  };
})
