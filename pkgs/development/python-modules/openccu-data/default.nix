{
  buildPythonPackage,
  fetchFromGitHub,
  lib,
  pytestCheckHook,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "openccu-data";
  version = "2026.9.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "SukramJ";
    repo = "openccu-data";
    tag = finalAttrs.version;
    hash = "sha256-B4vnPcceT7XkRWFNmqV0QN1DI6+q64XNI5XYgWEV354=";
  };

  build-system = [ setuptools ];

  pythonImportsCheck = [ "openccu_data" ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  meta = {
    changelog = "https://github.com/SukramJ/openccu-data/blob/${finalAttrs.src.tag}/changelog.md";
    description = "Extract and distribute Homematic CCU/OpenCCU configuration metadata";
    homepage = "https://github.com/SukramJ/openccu-data";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.dotlambda ];
  };
})
