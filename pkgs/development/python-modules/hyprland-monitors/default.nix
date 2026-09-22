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
  version = "0.9.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "BlueManCZ";
    repo = "hyprland-monitors";
    tag = "v${finalAttrs.version}";
    hash = "sha256-7nrLBsU7QacSf5l0Y/LgegfHtx2qHBNCJUBz0cc3dLE=";
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
