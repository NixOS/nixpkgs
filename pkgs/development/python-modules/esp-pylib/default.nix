{
  buildPythonPackage,
  click,
  fetchFromGitHub,
  lib,
  pyserial,
  pytestCheckHook,
  rich,
  rich-click,
  setuptools,
  websockets,
}:

buildPythonPackage (finalAttrs: {
  pname = "esp-pylib";
  version = "1.2.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "espressif";
    repo = "esp-pylib";
    tag = "v${finalAttrs.version}";
    hash = "sha256-wj9Enkaxj6LlNfJlmditKFZ8lKfVq9SbQg8f5xIyXP8=";
  };

  build-system = [ setuptools ];

  dependencies = [
    rich
  ];

  optional-dependencies = {
    cli = [
      click
      rich-click
    ];
    ide = [
      websockets
    ];
    serial = [
      pyserial
    ];
  };

  pythonImportsCheck = [ "esp_pylib" ];

  nativeCheckInputs = [
    pytestCheckHook
  ]
  ++ lib.concatAttrValues finalAttrs.passthru.optional-dependencies;

  meta = {
    changelog = "https://github.com/espressif/esp-pylib/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    description = "Python library for logging, utils and constants for Espressif Systems' Python projects";
    homepage = "https://github.com/espressif/esp-pylib";
    license = lib.licenses.asl20;
    maintainers = [ lib.maintainers.dotlambda ];
  };
})
