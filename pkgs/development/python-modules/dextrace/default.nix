{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  nix-update-script,
  pytest-cov-stub,
  pytestCheckHook,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "dextrace";
  version = "26.9.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "ev-flow";
    repo = "DexTrace";
    tag = "v${finalAttrs.version}";
    hash = "sha256-4nayjwXK3I8APPuHPmMzvSSf0DSqssFObUnD5SVQPAA=";
  };

  build-system = [ setuptools ];

  nativeCheckInputs = [
    pytest-cov-stub
    pytestCheckHook
  ];

  pythonImportsCheck = [ "dextrace" ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Module for Android APK/DEX parsing and call-tracing";
    homepage = "https://github.com/ev-flow/DexTrace";
    changelog = "https://github.com/ev-flow/DexTrace/releases/tag/${finalAttrs.src.tag}";
    license = with lib.licenses; [
      gpl3Only
      gpl3Plus
    ];
    maintainers = with lib.maintainers; [ fab ];
  };
})
