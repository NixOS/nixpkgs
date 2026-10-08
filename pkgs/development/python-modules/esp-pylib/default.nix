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
  version = "1.1.4";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "espressif";
    repo = "esp-pylib";
    tag = "v${finalAttrs.version}";
    hash = "sha256-anos6sLybT6HQXslFpmRl6+0gF1OjrQqe3UAPbgcTYI=";
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
