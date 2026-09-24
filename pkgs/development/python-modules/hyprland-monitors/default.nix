{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  hatchling,
  hyprland-socket,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "hyprland-monitors";
  version = "0.8.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "BlueManCZ";
    repo = "hyprland-monitors";
    tag = "v${finalAttrs.version}";
    hash = "sha256-a7fEDPPN9XYsrpE99C9c9MZGpqg24ZlY6vvHzgvNtzc=";
  };

  build-system = [ hatchling ];

  dependencies = [ hyprland-socket ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "hyprland_monitors" ];

  meta = {
    description = "Monitor management utilities for Hyprland";
    homepage = "https://github.com/BlueManCZ/hyprland-monitors";
    changelog = "https://github.com/BlueManCZ/hyprland-monitors/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ sophronesis ];
  };
})
