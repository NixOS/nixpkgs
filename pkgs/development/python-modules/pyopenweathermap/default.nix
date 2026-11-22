{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  poetry-core,

  # dependencies
  aiohttp,

  # tests
  pytest-asyncio,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "pyopenweathermap";
  version = "0.3.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "freekode";
    repo = "pyopenweathermap";
    tag = "v${finalAttrs.version}";
    hash = "sha256-+mfGX9ZsB/NnTE9ChOeM7a7ms4KbxaaqEIJ6SucyrTo=";
  };

  build-system = [ poetry-core ];

  dependencies = [ aiohttp ];

  nativeCheckInputs = [
    pytest-asyncio
    pytestCheckHook
  ];

  disabledTestMarks = [
    "network"
  ];

  pythonImportsCheck = [ "pyopenweathermap" ];

  meta = {
    description = "Python library for OpenWeatherMap API for Home Assistant";
    homepage = "https://github.com/freekode/pyopenweathermap";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ hexa ];
  };
})
