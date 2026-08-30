{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  setuptools-scm,
  typing-extensions,
  pytestCheckHook,
  pytest-asyncio,
  pytest-cov-stub,
  pytest-timeout,
}:

buildPythonPackage (finalAttrs: {
  pname = "aiospinel";
  version = "1.2.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "home-assistant-libs";
    repo = "aiospinel";
    tag = "v${finalAttrs.version}";
    hash = "sha256-AMIrm9AGFjRSDwJtDXcOH9HIBFiqszjjNma+egRa5Tw=";
  };

  build-system = [
    setuptools
    setuptools-scm
  ];

  dependencies = [
    typing-extensions
  ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-asyncio
    pytest-cov-stub
    pytest-timeout
  ];

  pythonImportsCheck = [
    "aiospinel"
  ];

  __structuredAttrs = true;

  meta = {
    description = "Asyncio implementation of the Spinel protocol used to communicate with OpenThread RCPs over a serial connection";
    homepage = "https://github.com/home-assistant-libs/aiospinel";
    changelog = "https://github.com/home-assistant-libs/aiospinel/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ hexa ];
  };
})
