{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  hatchling,
  hyprland-config,
  hyprland-monitors,
  hyprland-schema,
  hyprland-socket,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "hyprland-state";
  version = "0.4.7";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "BlueManCZ";
    repo = "hyprland-state";
    tag = "v${finalAttrs.version}";
    hash = "sha256-XeD01ER5PDGFqdYerx0OlWXtn0WEUVwspwObWscz6W8=";
  };

  build-system = [ hatchling ];

  dependencies = [
    hyprland-config
    hyprland-monitors
    hyprland-schema
    hyprland-socket
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "hyprland_state" ];

  meta = {
    description = "Live state interface for Hyprland - options, animations, monitors, binds, and devices";
    homepage = "https://github.com/BlueManCZ/hyprland-state";
    changelog = "https://github.com/BlueManCZ/hyprland-state/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ sophronesis ];
  };
})
