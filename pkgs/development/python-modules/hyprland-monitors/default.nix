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
  version = "0.7.0";
  pyproject = true;

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "BlueManCZ";
    repo = "hyprland-monitors";
    tag = "v${finalAttrs.version}";
    hash = "sha256-83h9rcavYie9QYjRMmN3akmALS+4orvMldIUt7vf/Qc=";
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
