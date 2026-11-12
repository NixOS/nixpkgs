{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  hatchling,
  pytestCheckHook,
  ruff,
}:

buildPythonPackage (finalAttrs: {
  pname = "hyprland-schema";
  version = "0.7.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "BlueManCZ";
    repo = "hyprland-schema";
    tag = "v${finalAttrs.version}";
    hash = "sha256-/ynmTlDGreez72X9jVOJ0z999LaefiCCe7REllRH83E=";
  };

  build-system = [ hatchling ];

  nativeCheckInputs = [
    pytestCheckHook
    # load-bearing: generate_schema.py formats the module it emits with ruff, and
    # test_generate.py asserts on the resulting double-quote style. Without ruff on
    # PATH that formatting is silently skipped and the test fails.
    ruff
  ];

  pythonImportsCheck = [ "hyprland_schema" ];

  meta = {
    description = "Typed Python schema for every Hyprland configuration option";
    homepage = "https://github.com/BlueManCZ/hyprland-schema";
    changelog = "https://github.com/BlueManCZ/hyprland-schema/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ sophronesis ];
  };
})
