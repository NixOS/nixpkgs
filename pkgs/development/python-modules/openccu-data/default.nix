{
  buildPythonPackage,
  fetchFromGitHub,
  lib,
  pytestCheckHook,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "openccu-data";
  version = "2026.6.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "SukramJ";
    repo = "openccu-data";
    tag = finalAttrs.version;
    hash = "sha256-iG9TKQQH8wM9sEHfaSPfWwbledwCSS/OlnTZ059l774=";
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
