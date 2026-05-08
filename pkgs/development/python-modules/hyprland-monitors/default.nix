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
  version = "0.5.0";
  pyproject = true;

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "BlueManCZ";
    repo = "hyprland-monitors";
    tag = "v${finalAttrs.version}";
    hash = "sha256-xT+ihpH31RIUInywv437Oji5LDk+vjIkLBJogJMN/J8=";
  };

  build-system = [ hatchling ];

  dependencies = [ hyprland-socket ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "hyprland_monitors" ];

  # tests require running Hyprland instance
  doCheck = false;

  meta = {
    description = "Monitor management utilities for Hyprland";
    homepage = "https://github.com/BlueManCZ/hyprland-monitors";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ sophronesis ];
  };
})
