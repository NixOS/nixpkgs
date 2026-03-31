{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  hatchling,
  hyprland-socket,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "hyprland-monitors";
  version = "0.4.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "BlueManCZ";
    repo = "hyprland-monitors";
    tag = "v${version}";
    hash = "sha256-keJnu8DMnDJGR0Dq+AzBRodyRxy1ErzcoIwEg/kFGBU=";
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
}
